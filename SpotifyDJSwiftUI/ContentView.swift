//
//  ContentView.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 25/3/2022.
//

import SwiftUI
import SQLite3

var setlists = [Setlist(title: "Setlist 1", id: "a", author: "me", tracks: [Track(id: "z", title: "My Track", duration: 12202)]), Setlist(title: "Setlist 2", id: "b", author: "Not Me", tracks: [Track(id: "y", title: "2's first track", duration: 14324), Track(id: "x", title: "2's second track", duration: 1204)])]

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    Search()
                } label: {
                    Label("Connect", systemImage: "info.circle")
                }
                NavigationLink {
                    Search()
                } label: {
                    Label("Search", systemImage: "gear")
                }
                NavigationLink {
                    Search()
                } label: {
                    Label("Setlists", systemImage: "books.vertical")
                }
                
                Divider()
                
                Label("Create setlist", systemImage: "plus.square")
                
                
                ForEach(setlists) { setlist in
                    NavigationLink(destination: SetlistView(setlist: setlist)) {
                        Text(setlist.title)
                    }
                    
                }
            }
            .navigationTitle("SpotifyDJ")
            .listStyle(SidebarListStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.landscapeLeft)
    }
}
