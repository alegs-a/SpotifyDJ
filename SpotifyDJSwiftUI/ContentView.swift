//
//  ContentView.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 25/3/2022.
//

import SwiftUI
import SQLite3

let pathToDatabase = "/Users/alex/Documents/School/2022/Digital/IA2/SpotifyDJSwiftUI/SpotifyDJSwiftUI/database.db"

struct ContentView: View {
    @State private var setlists: [Setlist]
    @State private var users: [User]
    @State private var showingAddSetlist: Bool = false
    
    let db: SQLiteDatabase
    
    init() {
        try! db = SQLiteDatabase.open(path: pathToDatabase)
        /* Why it's fine to ignore errors from SQLiteDatabase.open()
         `try!` asserts at runtime that SQLiteDatabase.open() will not throw an error, despite it being a throwing function. This is appropriate because database.db is bundled with the app at compile time, meaning that it will never not be present. Were it to be lost, the entire functionality of the app would be lost, so a catastrophic runtime error is appropriate.
         */
        setlists = db.getSetlists() ?? []
        users = db.getUsers()
    }

    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    SearchUsers(users: $users)
                } label: {
                    Label("Connect", systemImage: "person.2")
                }
                NavigationLink {
                    SearchTracks(setlists: $setlists)
                } label: {
                    Label("Search tracks", systemImage: "magnifyingglass")
                }
                NavigationLink {
                    SearchSetlists(setlists: $setlists)
                } label: {
                    Label("Setlists", systemImage: "books.vertical")
                }
                
                Divider()
                
                NavigationLink {
                    SearchSetlists(setlists: $setlists)
                } label: {
                    Label("Search setlists", systemImage: "magnifyingglass")
                }
                
                Button {
                        showingAddSetlist.toggle()
                } label: {
                    Label("Create setlist", systemImage: "plus.square")
                }
                    .sheet(isPresented: $showingAddSetlist) {
                        CreateSetlist(setlists: $setlists)
                    }
            
                ForEach(setlists) { setlist in
                    NavigationLink(destination: SetlistView(setlist: setlist, setlists: $setlists)) {
                        Text(setlist.title)
                    }
                }
            }
            .navigationTitle("DJ Companion")
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
