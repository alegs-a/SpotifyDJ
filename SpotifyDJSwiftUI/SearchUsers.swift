//
//  SearchUsers.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 2/5/2022.
//

import SwiftUI

struct SearchUsers: View {
    @Binding var users: [User]
    @State var searchQuery: String = ""
    
    var body: some View {
        NavigationView {
            SearchUsersResults(users: $users, searchQuery: $searchQuery)
        }
        .searchable(text: $searchQuery, prompt: "Search for users by name, author or ID")
        .navigationViewStyle(.stack)
        .navigationTitle("Browse users")
    }
}

//struct SearchUsers_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchUsers()
//    }
//}
