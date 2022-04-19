//
//  SetlistView.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 29/3/2022.
//

import SwiftUI

struct SetlistView: View {
    
    @Binding var setlist: Setlist
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(setlist.title)
                .font(.largeTitle)
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
                .onMove(perform: move)
            }
            .toolbar {
                EditButton()
            }
        }
        .padding()
    }
    func move(from source: IndexSet, to destination: Int) {
        setlist.tracks.move(fromOffsets: source, toOffset: destination)
    }
}

//struct SetlistView_Previews: PreviewProvider {
//    static var previews: some View {
//        SetlistView($setlists[0])
//    }
//}
