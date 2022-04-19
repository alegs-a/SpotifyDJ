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
    @State private var showingAddSetlist: Bool = false
    
    let db: SQLiteDatabase
    
    init() {
        try! db = SQLiteDatabase.open(path: pathToDatabase)
        /* Why it's fine to ignore errors from SQLiteDatabase.open()
         `try!` asserts at runtime that SQLiteDatabase.open() will not throw an error, despite it being a throwing function. This is appropriate because database.db is bundled with the app at compile, meaning that it will never not be present. Were it to be lost, the entire functionality of the app would be lost, so a catastrophic runtime error is appropriate.
         */
        setlists = db.getSetlists() ?? []
    }

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
                
                Button("Create Setlist") {
                            showingAddSetlist.toggle()
                        }
                        .sheet(isPresented: $showingAddSetlist) {
                            CreateSetlist(setlists: $setlists)
                        }
                
                ForEach($setlists) { $setlist in
                    NavigationLink(destination: SetlistView(setlist: $setlist)) {
                        /* Making this binding work took bloody ages, solution and explanation in Paul B's answer at https://stackoverflow.com/questions/57340575/binding-and-foreach-in-swiftui*/
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
