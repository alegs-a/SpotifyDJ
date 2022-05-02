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
            HStack {
                Text(setlist.title)
                    .font(.largeTitle)
                Spacer()
            }
            Divider()
            HStack {
                Text(setlist.author.name)
                Text("|")
                Text("Duration: \(setlist.durationMinsSecs)")
                Text("ID: \(setlist.id)")
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

//struct SetlistView_Previews: PreviewProvider {
//    static var previews: some View {
//        SetlistView($setlists[0])
//    }
//}
