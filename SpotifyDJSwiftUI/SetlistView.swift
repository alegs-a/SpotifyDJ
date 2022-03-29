//
//  SetlistView.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 29/3/2022.
//

import SwiftUI

struct SetlistView: View {
    var setlist: Setlist
    var body: some View {
        Text("title: \(setlist.title)")
    }
}

struct SetlistView_Previews: PreviewProvider {
    static var previews: some View {
        SetlistView(setlist: setlists[0])
    }
}
