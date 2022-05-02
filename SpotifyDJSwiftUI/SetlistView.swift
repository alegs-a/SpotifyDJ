//
//  SetlistView.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 29/3/2022.
//

import SwiftUI

struct SetlistView: View {
    
    var setlist: Setlist
    @Binding var setlists: [Setlist]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(setlist.title)
                    .font(.largeTitle)
                Spacer()
            }
            Divider()
            HStack {
                NavigationLink(setlist.author.name, destination: UserDetail(user: setlist.author))
                Text("|")
                Text("Duration: \(setlist.durationMinsSecs)")
                Text("|")
                Text("ID: \(setlist.id)")
            }
            List {
                ForEach(setlist.tracks) { track in
                    TrackRow(track: track, setlists: $setlists)
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
