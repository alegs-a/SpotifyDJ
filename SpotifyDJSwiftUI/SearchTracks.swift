//
//  Search.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 25/3/2022.
//

import SwiftUI

struct SearchTracks: View {
    var body: some View {
        let db = try! SQLiteDatabase.open(path: pathToDatabase)
        var tracks: [Track] = try! db.getTracks()
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        SearchTracks()
.previewInterfaceOrientation(.landscapeLeft)
    }
}
