//
//  UserDetail.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 2/5/2022.
//

import SwiftUI

struct UserDetail: View {
    var user: User
    var body: some View {
        let userColor = Color.random
        ScrollView {
            ZStack {
                Rectangle()
                    .foregroundColor(userColor)
                    .grayscale(0.8)
            }
            .ignoresSafeArea(edges: .top)
            .frame(height: 300)
            
            ZStack(alignment: .center) {
                Circle()
                    .foregroundColor(userColor)
                    .frame(width: 300, height: 300)
                    .shadow(radius: 7)
                Text((user.name.first?.uppercased())!)
                    .font(.system(size: 160))
                    .fontWeight(.heavy)
            }
            .offset(y:-150)
            .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.title)
                Text(user.description)
            }
            .padding()
            Spacer()
        }
    }
}

struct UserDetail_Previews: PreviewProvider {
    static var previews: some View {
        UserDetail(user: User(id: 1, name: "Default user", description: "a cool escription that is actually way longer than you thought i masdf lsdfks dfl sdflkslkadf as;k dfaskl;dfkl asjkl as dfjklasdfjkl asdjkl f asjkldfjklasdf jklads lfjkajkl s asdf ajkl dklajsdf jkl asf jkl afd jklasdf asd jklaf "))
    }
}
