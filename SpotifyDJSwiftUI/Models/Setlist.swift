//
//  Setlist.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 29/3/2022.
//

import Foundation

struct Setlist: Identifiable {
    var title: String
    var id: String
    var duration: Int {
        // Duration is computed property; only has getter method, so cannot be written to. 
        var totalDuration = 0
        for track in tracks {
            totalDuration += track.duration
        }
        return totalDuration
    }
    var author: String
    var tracks: [Track]
    var NStitle: NSString { title as NSString }
}
