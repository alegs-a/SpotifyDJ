//
//  Search.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 25/3/2022.
//

import SwiftUI

struct SearchTracks: View {
    
    @State private var searchQuery: String = ""
    @State private var SearchEventType: EventType = .none
    @Binding var setlists: [Setlist]
    
    var body: some View {
        let db = try! SQLiteDatabase.open(path: pathToDatabase)
        let tracks: [Track] = try! db.getTracks()
        VStack(alignment: .leading) {
            Text("Browse tracks")
                .font(.largeTitle)
            SearchBar(text: $searchQuery)
            
            HStack {
                Text("Event type: ")
                Picker("Event type", selection: $SearchEventType) {
                    Text("Dance party").tag(EventType.danceParty)
                    Text("Wedding").tag(EventType.wedding)
                    Text("Restaurant dining").tag(EventType.RestaurantDining)
                    Text("None").tag(EventType.none)
                }
            }
            .padding(25)
            
            switch SearchEventType {
            case .danceParty:
                List(tracks.filter({ $0.trackContainsString(searchQuery: searchQuery) && $0.suitableDanceParty })) { track in
                    TrackRow(track: track, setlists: $setlists)
                }
            case .wedding:
                List(tracks.filter({ $0.trackContainsString(searchQuery: searchQuery) && $0.suitableWedding })) { track in
                    TrackRow(track: track, setlists: $setlists)
                }
            case .RestaurantDining:
                List(tracks.filter({ $0.trackContainsString(searchQuery: searchQuery) && $0.suitableRestaurantDining })) { track in
                    TrackRow(track: track, setlists: $setlists)
                }
            case .none:
                List(tracks.filter({ $0.trackContainsString(searchQuery: searchQuery)})) { track in
                    TrackRow(track: track, setlists: $setlists)
                }
            }
        }
        .padding()
    }
}

//struct Search_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchTracks()
//.previewInterfaceOrientation(.landscapeLeft)
//    }
//}
