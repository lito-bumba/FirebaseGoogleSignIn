//
//  UserCard.swift
//  FirebaseGoogleSignIn
//
//  Created by Cazombo Bumba on 15/02/24.
//

import SwiftUI

struct UserCard: View {
    let user: User
    let onSignOut: () -> Void
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: user.image))
                .clipShape(Circle())
            Text(user.name)
                .font(.title)
            Text(user.email)
            Button(action: onSignOut){
                Text("Sign Out")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            .background(.primary)
            .cornerRadius(13.0)
        }
    }
}

#Preview {
    UserCard(
        user: User(
            name: "Lito Bumba",
            email: "litocdbumba@gmail.com",
            image: "https://avatars.githubusercontent.com/u/90806272?v=4"
        ),
        onSignOut: { }
    )
}
