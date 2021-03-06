//
//  User.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 10/4/2022.
//

import Foundation

struct User: Identifiable {
    var id: Int
    var name: String
    var description: String
    
    func containsSearchQuery(searchQuery: String) -> Bool {
        if name.localizedCaseInsensitiveContains(searchQuery) || description.localizedCaseInsensitiveContains(searchQuery) {
            return true
        }
        return false
    }
}
