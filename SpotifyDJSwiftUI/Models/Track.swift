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
    var duration: Int // track duration in milliseconds
    var HMSduration: String {
        let totalSeconds: Int = duration/1000 // implicitly returns Int
        let totalMinutes: Int = totalSeconds/60
        let remainderSeconds: Int = totalSeconds%totalMinutes
        return "\(totalMinutes):\(remainderSeconds)"
    }
    var CDuration: Int32 { Int32("\(duration)") ?? 0 }
    
}
