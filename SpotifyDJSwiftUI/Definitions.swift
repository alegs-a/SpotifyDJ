//
//  Functions.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 30/3/2022.
//

import Foundation
import SQLite3
import SwiftUI

func millisToMinsSecs(milliseconds: Int) -> String {
    let totalSeconds: Int = milliseconds/1000 // Division of two Ints implicitly returns Int
    let totalMinutes: Int = totalSeconds/60
    if totalMinutes == 0 { // Catches division by 0 error in `totalSeconds%totalMinutes`
        var output = "\(totalMinutes):"
        if String(totalSeconds).count == 1 {
            output += "0\(totalSeconds)"
        } else {
            output += String(totalSeconds)
        }
        return output
    } // Implicit 'else' since if clause returns
        let remainderSeconds: Int = totalSeconds % 60
        var output = "\(totalMinutes):"
        if String(remainderSeconds).count == 1 {
            output += "0\(remainderSeconds)"
        } else {
            output += String(remainderSeconds)
        }
        return output
}

func categoriseTrackValue(value: Double) -> String {
    switch value {
    case 0.8...1:
        return "high"
    case 0.6..<0.8:
        return "med"
    default:
        return "low"
    }
}

extension Color {
    static var random: Color {
        /* Used to generate random color for user profile*/
        return Color(
            red: .random(in: 0...0.5),
            green: .random(in: 0...0.5),
            blue: .random(in: 0...0.5)
        )
    }
}

enum SQLiteError: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
    case UpdateSetlist(message: String)
}

enum EventType: String, CaseIterable, Identifiable {
    case danceParty, wedding, RestaurantDining, none
    var id: Self { self }
}

class SQLiteDatabase {
    private let dbPointer: OpaquePointer?
    private init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
    }
    deinit {
        sqlite3_close(dbPointer)
    }
    
    static func open(path: String) throws -> SQLiteDatabase {
        var db: OpaquePointer?
        if sqlite3_open(path, &db) == SQLITE_OK {
            print("DEBUG: Database connected")
            return(SQLiteDatabase(dbPointer: db))
        } else {
            defer { // `defer` statement is run when execution leaves the current scope, i.e. the `else` clause. This avoids awkward conditionals to make sure the database connection is closed no matter the path execution takes.
                if db != nil {
                    sqlite3_close(db)
                }
            }
            if let errorPointer = sqlite3_errmsg(db) {
                let message = String(cString: errorPointer)
                throw SQLiteError.OpenDatabase(message: message)
            } else {
                throw SQLiteError.OpenDatabase(message: "Database failed to open: no error message provided from sqlite.")
            }
        }
    }
    
    fileprivate var errorMessage: String {
        /* Computed property accesses the last error message returned by SQLite, if it exists, and if not returns a string reflecting that.
         `fileprivate` indicates that this variable is private to this file, i.e. an `extension` to SQLiteDatabase defined elsewhere could not access it. */
        if let errorPointer = sqlite3_errmsg(dbPointer) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        } else {
            return "No error message from SQLite3"
        }
    }
}

extension SQLiteDatabase {
    func prepareStatement(sql: String) throws -> OpaquePointer? {
        /* prepareStatement() returns a compiled SQL statement if it compiles OK, and an error if compilation fails.*/
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            print("DEBUG: Failed to compile SQL statement")
            throw SQLiteError.Prepare(message: errorMessage)
        }
        return statement
    }
}

extension SQLiteDatabase {
    func createSetlist(name: String, authorUserID: Int, description: String) throws {
        /* Adds the passed Setlist to the setlists table in SQL database */
        let insertSQL = "INSERT INTO setlists (name, author_user_ID, description) VALUES (?, ?, ?)" // setlist_ID is omitted since it is a PRIMARY KEY AUTOINCREMENT field, meaning it automatically populates itself with a unique value upon record creation.
        let insertStatement = try prepareStatement(sql: insertSQL )
        defer { sqlite3_finalize(insertStatement) }
        guard
            sqlite3_bind_text(insertStatement, 1, NSString(string: name).utf8String, -1, nil) == SQLITE_OK
                && sqlite3_bind_int(insertStatement, 2, Int32(Double(authorUserID))) == SQLITE_OK
                && sqlite3_bind_text(insertStatement, 3, NSString(string: description).utf8String, -1, nil) == SQLITE_OK
        else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("DEBUG: Successfully created setlist")
    }
}

extension SQLiteDatabase {
    func getGenresForTrack(trackID: String) -> [String] {
        let querySQL = "SELECT genre FROM genres WHERE track_ID = '\(trackID)';"
        guard let queryStatement = try? prepareStatement(sql: querySQL) else {
            return []
        }
        defer { sqlite3_finalize(queryStatement) }
        var output: [String] = []
        while sqlite3_step(queryStatement) == SQLITE_ROW {
            output.append(String(cString: sqlite3_column_text(queryStatement, 0)))
        }
        return output
    }
}

extension SQLiteDatabase {
    func getTrack(trackID: String) -> Track? {
        let querySQL = "SELECT track_ID, title, duration_ms, key, mode, tempo, danceability, energy, loudness, speechiness, acousticness, instrumentalness, liveness, valence, time_signature FROM tracks WHERE track_ID = '\(trackID)';"
        guard let queryStatement = try? prepareStatement(sql: querySQL) else {
            return nil
        }
        defer { sqlite3_finalize(queryStatement) }
        var output: Track?
        while sqlite3_step(queryStatement) == SQLITE_ROW {
             output = Track( // These fields are in the wrong order
                id: String(cString: sqlite3_column_text(queryStatement, 0)),
                title: String(cString: sqlite3_column_text(queryStatement, 1)),
                duration: Int(sqlite3_column_int(queryStatement, 2)),
                key: Int(sqlite3_column_int(queryStatement, 3)),
                mode: Int(sqlite3_column_int(queryStatement, 4)),
                tempo: Double(sqlite3_column_double(queryStatement, 5)),
                danceability: Double(sqlite3_column_double(queryStatement, 6)),
                energy: Double(sqlite3_column_double(queryStatement, 7)),
                loudness: Double(sqlite3_column_double(queryStatement, 8)),
                speechiness: Double(sqlite3_column_double(queryStatement, 9)),
                acousticness: Double(sqlite3_column_double(queryStatement, 10)),
                instrumentalness: Double(sqlite3_column_double(queryStatement, 11)),
                liveness: Double(sqlite3_column_double(queryStatement, 12)),
                valence: Double(sqlite3_column_double(queryStatement, 13)),
                genres: getGenresForTrack(trackID: String(cString: sqlite3_column_text(queryStatement, 0)))
            )
        }
        return output
    }
}

extension SQLiteDatabase {
    func getTracks() throws -> [Track] {
        let querySQL = "SELECT track_ID, title, duration_ms, key, mode, tempo, danceability, energy, loudness, speechiness, acousticness, instrumentalness, liveness, valence, time_signature FROM tracks ORDER BY key LIMIT 100;"
        guard let queryStatement = try? prepareStatement(sql: querySQL) else {
            throw SQLiteError.Prepare(message: errorMessage)
        }
        defer { sqlite3_finalize(queryStatement) }
        var output: [Track] = []
        while sqlite3_step(queryStatement) == SQLITE_ROW {
            output.append(
                Track(
                    id: String(cString: sqlite3_column_text(queryStatement, 0)),
                    title: String(cString: sqlite3_column_text(queryStatement, 1)),
                    duration: Int(sqlite3_column_int(queryStatement, 2)),
                    key: Int(sqlite3_column_int(queryStatement, 3)),
                    mode: Int(sqlite3_column_int(queryStatement, 4)),
                    tempo: Double(sqlite3_column_double(queryStatement, 5)),
                    danceability: Double(sqlite3_column_double(queryStatement, 6)),
                    energy: Double(sqlite3_column_double(queryStatement, 7)),
                    loudness: Double(sqlite3_column_double(queryStatement, 8)),
                    speechiness: Double(sqlite3_column_double(queryStatement, 9)),
                    acousticness: Double(sqlite3_column_double(queryStatement, 10)),
                    instrumentalness: Double(sqlite3_column_double(queryStatement, 11)),
                    liveness: Double(sqlite3_column_double(queryStatement, 12)),
                    valence: Double(sqlite3_column_double(queryStatement, 13)),
                    genres: getGenresForTrack(trackID: String(cString: sqlite3_column_text(queryStatement, 0)))
                )
            )
        }
        return output
    }
}

extension SQLiteDatabase {
    func getTracksFromSetlist(setlistID: Int) -> [Track] {
        /* select tracks from setlist_tracks which */
        let querySQL = "SELECT trackID FROM setlist_tracks WHERE setlistID = \(setlistID);"
        guard let queryStatement = try? prepareStatement(sql: querySQL) else {
            return []
        }
        defer {
            sqlite3_finalize(queryStatement)
        }
        var output: [Track] = []
        while sqlite3_step(queryStatement) == SQLITE_ROW {
            output.append(getTrack(trackID: String(cString: sqlite3_column_text(queryStatement, 0)))!)
        }
        return output
    }
}

extension SQLiteDatabase {
    func getSetlists() -> [Setlist]? {
        let querySQL = "SELECT setlist_ID, name, author_user_ID, description FROM setlists;"
        guard let queryStatement = try? prepareStatement(sql: querySQL) else {
            return nil
        }
        defer {
            sqlite3_finalize(queryStatement)
        }
        var output: [Setlist] = []
        while sqlite3_step(queryStatement) == SQLITE_ROW {
            output.append(
                Setlist(
                    /* NOTE: Because the table 'setlists' was declared with the field
                        setlist_ID INTEGER PRIMARY KEY AUTOINCREMENT,
                     SQLite does not create the extra hidden field 'rowID' as it usually would. I can only assume that rowID is silently passed to any SELECT statements made, which creates the 1-indexed weirdness that is usually present. However, because the field rowID does not exist in the table setlists and therefore is not passed, we can use a zero-index to access our results like normal programmers.*/
                    id: Int(sqlite3_column_int(queryStatement, 0)),
                    title: String(cString: sqlite3_column_text(queryStatement, 1)),
                    author: getUser(userID: Int(sqlite3_column_int(queryStatement, 2)))!,
                    description: String(cString: sqlite3_column_text(queryStatement, 3)),
                    tracks: getTracksFromSetlist(setlistID: Int(sqlite3_column_int(queryStatement, 0)))
                )
            )
        }
        return output
    }
}

extension SQLiteDatabase {
    func addTrackToSetlist(trackID: String, setlistID: Int) throws {
        let querySQL = "INSERT INTO setlist_tracks (trackID, setlistID) VALUES ('\(trackID)', \(setlistID));"
        guard let queryStatement = try? prepareStatement(sql: querySQL) else {
            throw SQLiteError.UpdateSetlist(message: errorMessage)
        }
        sqlite3_finalize(queryStatement)
    }
}

extension SQLiteDatabase {
    func createUser(name: String, description: String) {
        let querySQL = "INSERT INTO users (name, bio) VALUES ('\(name)', '\(description)');"
        let queryStatement = try! prepareStatement(sql: querySQL)
        sqlite3_finalize(queryStatement)
    }
}

extension SQLiteDatabase {
    func getUser(userID: Int) -> User? {
        let querySQL = "SELECT user_ID, name, bio FROM users WHERE user_ID = \(userID);"
        guard let queryStatement = try? prepareStatement(sql: querySQL) else {
            return nil
        }
        defer { sqlite3_finalize(queryStatement) }
        while sqlite3_step(queryStatement) == SQLITE_ROW {
            return User(
                id: Int(sqlite3_column_int(queryStatement, 0)),
                name: String(cString: sqlite3_column_text(queryStatement, 1)),
                description: String(cString: sqlite3_column_text(queryStatement, 2))
            )
        }
        return nil
    }
}

extension SQLiteDatabase {
    func getUsers() -> [User] {
        let querySQL = "SELECT user_ID FROM users;"
        guard let queryStatement = try? prepareStatement(sql: querySQL) else {
            return []
        }
        var output: [User] = []
        while sqlite3_step(queryStatement) == SQLITE_ROW {
            output.append(getUser(userID: Int(sqlite3_column_int(queryStatement, 0)))!)
        }
        return output
    }
}
