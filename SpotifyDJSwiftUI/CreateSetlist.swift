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
    var oldSetlist: Setlist?
    @State private var newName: String = ""
    @State private var newDescription: String = ""
    
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") { dismiss() }
                Spacer()
                Button("Save") { // Create new setlist in db and update setlists var
                    /* TODO:
                     Put logic here to determine whether oldName and oldDescription was passed and if so update existing setlist rather than create new one.*/
                    let db = try! SQLiteDatabase.open(path: pathToDatabase)
                    if oldSetlist != nil {
                        var newSetlist: Setlist = oldSetlist!
                        newSetlist.title = $newName.wrappedValue
                        newSetlist.description = $newDescription.wrappedValue
                        do {
                            try db.updateSetlist(setlist: newSetlist)
                        } catch {
                            print("Failed to update setlist with ID \(newSetlist.id)")
                        }
                    }
                    do {
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
