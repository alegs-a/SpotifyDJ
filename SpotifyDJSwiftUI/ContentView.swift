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
//    = [Setlist(id: "a", title: "Setlist 1", author: "me", tracks: [Track(id: "z", title: "My Track", artist: "Bananas Man", duration: 197499)]), Setlist(id: "b", title: "Setlist 2", author: "Not Me", tracks: [Track(id: "y", title: "Longest song", artist: "Very Cool Songwriter", duration: 507998), Track(id: "x", title: "Shortest song", artist: "A Very Cool and Awesome Artist with a Very Long Name that is truly ridicuolous", duration: 25600)])]
    
    let db: SQLiteDatabase
    
    init() {
        do {
            try db = SQLiteDatabase.open(path: pathToDatabase)
            print("Database connection: Database connected successfully")
        } catch SQLiteError.OpenDatabase(_) {
            print("Database connection: Failed to connect to database")
        } catch {
            print("Something has gone horribly terribly wrong")
        }
        
        
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
                
                Label("Create setlist", systemImage: "plus.square")
                
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
