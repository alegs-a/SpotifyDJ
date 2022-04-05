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
                VStack(alignment: .leading) {
                    Text(track.title)
                    Text(track.artist)
                        .font(.caption)
                        .frame(width: 200)
                        .lineLimit(1)
                }
                Spacer()
            }
            HStack {
                Text(String(track.HMSduration))
                Spacer()
                Menu {
                    Button("Dummy action", action: doNothing)
                } label: {
                    Image(systemName: "ellipsis")
                }
                
                
            }
        }
//        .padding(.leading)
//        .padding(.trailing)
    }
}

struct TrackRow_Previews: PreviewProvider {
    static var previews: some View {
        TrackRow(track: Setlist(id: "a", title: "Setlist 1", author: "me", tracks: [Track(id: "z", title: "My Track", artist: "Bananas Man", duration: 197499)]).tracks[0])
//        TrackRow(track: setlists[1].tracks[0])
//            .frame(width: 700, height: 80)
    }
}
