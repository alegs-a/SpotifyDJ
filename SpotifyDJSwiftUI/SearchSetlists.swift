//
//  SearchSetlists.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 2/5/2022.
//

import SwiftUI

struct SearchSetlists: View {
    @State var searchQuery: String = ""
    @Binding var setlists: [Setlist]
    
    var body: some View {
        NavigationView {
            SearchSetlistsResults(setlists: $setlists, searchQuery: $searchQuery)
        }
        .searchable(text: $searchQuery, prompt: "Search for setlists by name, author or ID")
        .navigationViewStyle(.stack)
        .navigationTitle("Browse setlists")
    }
}

struct SearchSetlists_Previews: PreviewProvider {
    static var previews: some View {
        SearchSetlists(setlists: .constant([]))
    }
}
