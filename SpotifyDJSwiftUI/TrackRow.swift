//
//  TrackRow.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 29/3/2022.
//

import SwiftUI

struct TrackRow: View {
    var track: Track
    @Binding var setlists: [Setlist]
    
    let db = try! SQLiteDatabase.open(path: pathToDatabase)
    
    var body: some View {
        HStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(track.title)
                }
                Spacer()
                Text(track.readableGenres)
                    .foregroundColor(.gray)
                Spacer()
            }
            HStack {
                Text(String(track.HMSduration))
                Spacer()
                Menu {
                    Menu {
                        ForEach(setlists) { setlist in
                            Button(setlist.title, action: {
                                try! db.addTrackToSetlist(trackID: track.id, setlistID: setlist.id)
                                setlists = db.getSetlists()!
                            })
                        }
                    } label: {
                        Text("Add to setlist")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
                
                
            }
        }
    }
}

//struct TrackRow_Previews: PreviewProvider {
//    static var previews: some View {
//        TrackRow(track: Setlist(id: 1, title: "Setlist 1", author: User(id: 1, name: "Me", description: "no"), description: "Cool setlist bro", tracks: [Track(id: "z", title: "My Track", artist: "Bananas Man", duration: 197499)]).tracks[0])
////        TrackRow(track: setlists[1].tracks[0])
////            .frame(width: 700, height: 80)
//    }
//}
