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
    var duration: Int
    var author: String
    var tracks: [track]
    var NStitle: NSString { title as NSString }
}
