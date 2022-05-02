//
//  SearchUsersResults.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 2/5/2022.
//

import SwiftUI

struct SearchUsersResults: View {
    @Binding var users: [User]
    @Binding var searchQuery: String
    
    var filteredUsers: [User] {
        if searchQuery.isEmpty {
            return users
        } else {
            return users.filter {
                $0.containsSearchQuery(searchQuery: searchQuery)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredUsers) { user in
                NavigationLink(destination: UserDetail(user: user)) {
                    Text(user.name)
                }
            }
        }
    }
}

struct SearchUsersResults_Previews: PreviewProvider {
    static var previews: some View {
        SearchUsersResults(users: .constant([]), searchQuery: .constant(""))
    }
}
