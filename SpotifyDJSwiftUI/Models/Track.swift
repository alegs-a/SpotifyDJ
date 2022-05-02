//
//  Track.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 29/3/2022.
//

import Foundation

private var highThreshold: Float = 0.7
private var loudnessLowThreshold: Float = -8
    
struct Track: Identifiable {
    var id: String
    var title: String
    var duration: Int // track duration in milliseconds
    var key: Int
    var mode: Int
    var tempo: Float
    var danceability: Float
    var energy: Float
    var loudness: Float
    var speechiness: Float
    var acousticness: Float
    var instrumentalness: Float
    var liveness: Float
    var valence: Float
    var genres: [String]
    
    // Computed properties
    var HMSduration: String { millisToMinsSecs(milliseconds: duration) }
    var CDuration: Int32 { Int32("\(duration)") ?? 0 }
    var readableGenres: String {
        var output: String = ""
        for genre in genres {
            output += "\(genre.capitalized)  "
        }
        return output
    }
    
    var suitableDanceParty: Bool {
        if danceability > highThreshold && tempo > highThreshold && energy > highThreshold {
            return true
        } else {
            return false
        }
    }
    var suitableWedding: Bool {
        if danceability > highThreshold && loudness < loudnessLowThreshold && valence > highThreshold {
            return true
        } else {
            return false
        }
    }
    var suitableRestaurantDining: Bool {
        if acousticness > highThreshold && loudness < loudnessLowThreshold {
            return true
        } else {
            return false
        }
    }
}
