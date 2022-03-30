//
//  SetlistView.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 29/3/2022.
//

import SwiftUI

struct SetlistView: View {
    var setlist: Setlist
    var body: some View {
        VStack(alignment: .leading) {
            Text(setlist.title)
                .font(.largeTitle)
            HStack {
                Text(setlist.author)
                Text("|")
                Text("Duration: \(setlist.duration)")
            }
            List {
                ForEach(setlist.tracks) { track in
                    TrackRow(track: track)
                }
            }
        }
        .padding()
    }
}

struct SetlistView_Previews: PreviewProvider {
    static var previews: some View {
        SetlistView(setlist: setlists[1])
    }
}
