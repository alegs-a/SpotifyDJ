//
//  Track.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 29/3/2022.
//

import Foundation

struct Track: Identifiable {
    var id: String
    var title: String
    var artist: String
    var duration: Int // track duration in milliseconds
    var HMSduration: String { millisToMinsSecs(milliseconds: duration) }
    var CDuration: Int32 { Int32("\(duration)") ?? 0 }
    
}
