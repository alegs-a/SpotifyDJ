//
//  TrackRow.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 29/3/2022.
//

import SwiftUI

struct TrackRow: View {
    var track: Track
    
    var body: some View {
        HStack {
            HStack {
                Text(track.title)
                Spacer()
            }
            HStack {
                Text(String(track.duration))
                Spacer()
                Text(track.HMSduration)
            }
        }
        .padding(.leading)
    }
}

struct TrackRow_Previews: PreviewProvider {
    static var previews: some View {
        TrackRow(track: setlists[0].tracks[0])
    }
}
