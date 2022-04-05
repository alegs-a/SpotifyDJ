//
//  Setlist.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 29/3/2022.
//

import Foundation

struct Setlist: Identifiable {
    var id: String
    var title: String
    var author: String
    var tracks: [Track]
    var duration: Int {
        // Duration is computed property; only has getter method, so cannot be written to. 
        var totalDuration = 0
        for track in tracks {
            totalDuration += track.duration
        }
        return totalDuration
    }
    var durationMinsSecs: String { millisToMinsSecs(milliseconds: duration)}
    var NStitle: NSString { title as NSString }
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
