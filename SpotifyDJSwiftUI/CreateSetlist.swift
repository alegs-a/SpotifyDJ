//
//  CreateSetlist.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 10/4/2022.
//

import SwiftUI

struct CreateSetlist: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var setlists: [Setlist]
    
    
    
    var body: some View {
        VStack {
            Text("Create Setlist")
                .font(.title)
            Button("Press to dismiss") {
                $setlists.wrappedValue.append(Setlist(id: 5, title: "Setlist from sheet", author: User(id: 21, name: "Sheet", description: "ur mom"), description: "Its a setlist from the create setlist sheet", tracks: [Track(id: "4938", title: "dumb  track", artist: "ur mum", duration: 3829132)])) // Use .wrappedValue to access underlying value of $setlists, calling .append() on a value of type Binding<Array> throws an error.
                print($setlists.wrappedValue)
                
                //                $setlists.append(Setlist(id: 5, title: "Setlist from sheet", author: User(id: 21, name: "Sheet", description: "ur mom"), description: "Its a setlist from the create setlist sheet", tracks: [Track(id: "4938", title: "dumb  track", artist: "ur mum", duration: 3829132)]))
                dismiss()
            }
        }
    }
}

//struct CreateSetlist_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateSetlist()
//    }
//}
