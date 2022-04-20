//
//  Functions.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 30/3/2022.
//

import Foundation
import SQLite3

func millisToMinsSecs(milliseconds: Int) -> String {
    let totalSeconds: Int = milliseconds/1000 // implicitly returns Int
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
        let remainderSeconds: Int = totalSeconds%6
        var output = "\(totalMinutes):"
        if String(remainderSeconds).count == 1 {
            output += "0\(remainderSeconds)"
        } else {
            output += String(remainderSeconds)
        }
        return output
}

func move<T>(from source: IndexSet, to destination: Int, array: inout [T])  {
    array.move(fromOffsets: source, toOffset: destination)
}

enum SQLiteError: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
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
        defer {
            sqlite3_finalize(insertStatement)
        }
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
        print("DEBUG: Successfully inserted row")
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
            output.append(Setlist(
                /* NOTE: Because the table 'setlists' was declared with the field
                    setlist_ID INTEGER PRIMARY KEY AUTOINCREMENT,
                 SQLite does not create the extra hidden field 'rowID' as it usually would. I can only assume that rowID is silently passed to any SELECT statements made, which creates the 1-indexed weirdness that is usually present. However, because the field rowID does not exist in the table setlists and therefore is not passed, we can use a zero-index to access our results like normal programmers.*/
                id: Int(sqlite3_column_int(queryStatement, 0)),
                title: String(cString: sqlite3_column_text(queryStatement, 1)),
                author: User(id: 1, name: "dummy", description: "dummy"),
                description: String(cString: sqlite3_column_text(queryStatement, 3)),
                tracks: [])
            )
        }
        return output
    }
}


func doNothing() { } // For debugging purposes
