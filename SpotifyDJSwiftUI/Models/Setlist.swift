//
//  Setlist.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 29/3/2022.
//

import Foundation

struct Setlist: Identifiable {
    var id: Int
    var title: String
    var author: User
    var description: String
    var tracks: [Track]
    var duration: Int {
        // duration is computed property; only has getter method, so cannot be written to. 
        var totalDuration = 0
        for track in tracks {
            totalDuration += track.duration
        }
        return totalDuration
    }
    var durationMinsSecs: String { millisToMinsSecs(milliseconds: duration)}
    
    var i32id: Int32 { Int32(Double(id)) }
    var NStitle: NSString { title as NSString }
    var i32authorID: Int32 { Int32(Double(author.id)) }
    var NSdescription: NSString { description as NSString }
    
    func setlistContainsString(searchQuery: String) -> Bool {
        if String(id).localizedCaseInsensitiveContains(searchQuery) || title.localizedCaseInsensitiveContains(searchQuery) || author.name.localizedCaseInsensitiveContains(searchQuery) {
            return true
        } else {
            return false
        }
    }
}

/*
 func bind(_ e: String) {
    sqlite3_bind_text((e as NSString).utf8String)
 }
 func bind(_ e: Int) {
    sqlite3_bind_int(Int32(e))
 }
 func bind(_ e: Float) {
    sqlite3_bind_double(Float(e))
 }
 
 bind(title)
 bind(id)
 bind(danceability)
 */
