//
//  SearchSetlistsResults.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 2/5/2022.
//

import SwiftUI

struct SearchSetlistsResults: View {
    @Binding var setlists: [Setlist]
    @Binding var searchQuery: String
    
    var filteredSetlists: [Setlist] {
        if searchQuery.isEmpty {
            return setlists
        } else {
            return setlists.filter {
                $0.setlistContainsString(searchQuery: searchQuery)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredSetlists) { setlist in
                NavigationLink(destination: SetlistView(setlist: setlist)) {
                    Text(setlist.title)
                }
            }
        }
    }
}

struct SearchSetlistsResults_Previews: PreviewProvider {
    static var previews: some View {
        SearchSetlistsResults(setlists: .constant([]), searchQuery: .constant("banana"))
    }
}
