//
//  SetlistList.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 5/4/2022.
//

import SwiftUI

struct SetlistList: View {
    struct BoolItem: Identifiable {
          let id = UUID()
          var value: Bool = false
        }
        @State private var boolArr = [BoolItem(), BoolItem(), BoolItem(value: true), BoolItem(value: true), BoolItem()]

        var body: some View {
            NavigationView {
                VStack {
                List($boolArr) { $bi in
                    Toggle(isOn: $bi.value) {
                            Text(bi.id.description.prefix(5))
                                .badge(bi.value ? "ON":"OFF")
                    }
                }
                    Text(boolArr.map(\.value).description)
                }
                .navigationBarItems(leading:
                                        Button(action: { self.boolArr.append(BoolItem(value: .random())) })
                    { Text("Add") }
                    , trailing:
                    Button(action: { self.boolArr.removeAll() })
                    { Text("Remove All") })
            }
        }
}

struct SetlistList_Previews: PreviewProvider {
    static var previews: some View {
        SetlistList()
    }
}
