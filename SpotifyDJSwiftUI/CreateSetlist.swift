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
    @State private var newName: String = ""
    @State private var newDescription: String = ""
    var oldSetlist: Setlist?
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") { dismiss() }
                Spacer()
                Button("Save") { // Create new setlist in db and update setlists var
                    let db = try! SQLiteDatabase.open(path: pathToDatabase)
                    do { // use do-catch syntax to catch any errors from createSetlist()
                        try db.createSetlist(name: $newName.wrappedValue, authorUserID: 1, description: $newDescription.wrappedValue)
                    } catch {
                        print("DEBUG: Failed to create setlist")
                    }
                    $setlists.wrappedValue = db.getSetlists()!
                    // Use .wrappedValue to access underlying value of $setlists, calling .append() on a value of type Binding<Array> throws an error.
                    dismiss()
                }
            }
            Text("Create Setlist")
                .font(.title)
            Form {
                HStack {
                    Text("Title")
                    TextField("Required", text: $newName)
                }
                HStack {
                    Text("Description")
                    TextField("Required", text: $newDescription)
                }
            }
            .textFieldStyle(.roundedBorder)
        }
        .padding()
    }
}

//struct CreateSetlist_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateSetlist()
//    }
//}
