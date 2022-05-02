//
//  Track.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 29/3/2022.
//

import Foundation

private var highThreshold: Double = 0.7
private var loudnessLowThreshold: Double = -8
    
struct Track: Identifiable {
    var id: String
    var title: String
    var duration: Int // track duration in milliseconds
    var key: Int
    var mode: Int
    var tempo: Double
    var danceability: Double
    var energy: Double
    var loudness: Double
    var speechiness: Double
    var acousticness: Double
    var instrumentalness: Double
    var liveness: Double
    var valence: Double
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
        if categoriseTrackValue(value: danceability) == "high" && categoriseTrackValue(value: tempo) == "high" && categoriseTrackValue(value: energy) == "high" {
            return true
        } else {
            return false
        }
    }
    var suitableWedding: Bool {
        if categoriseTrackValue(value: danceability) == "high" && loudness < loudnessLowThreshold && categoriseTrackValue(value: valence) == "high" {
            return true
        } else {
            return false
        }
    }
    var suitableRestaurantDining: Bool {
        if categoriseTrackValue(value: acousticness) == "high" && loudness < loudnessLowThreshold {
            return true
        } else {
            return false
        }
    }
    
    func trackContainsString(searchQuery: String) -> Bool {
        for genre in genres {
            if genre.localizedCaseInsensitiveContains(searchQuery) {
                return true
            }
        }
        return title.localizedCaseInsensitiveContains(searchQuery) // Execution only reaches this line if none of the track's genres match the query, meaning that the value of title.localizedCaseInsensitiveContains() is the value the function should return
    }
}
