//
//  ContentView.swift
//  FirebaseGoogleSignIn
//
//  Created by Cazombo Bumba on 08/02/24.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth
import Firebase

struct ContentView: View {
    
    @State var currentUser: User? = nil
    
    var body: some View {
        VStack {
            if let user = currentUser {
                UserCard(user: user) {
                    GIDSignIn.sharedInstance.signOut()
                    print("sessão terminada")
                    currentUser = nil
                }
                .scaleEffect(1.0)
                .animation(.easeIn, value: 1.0)
            } else {
                Button(
                    action: {
                        Task {
                            currentUser = await signIn()
                        }
                    }
                ) {
                    Text("Sign In with Google")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding()
                }
                .background(.primary)
                .cornerRadius(14)
                .scaleEffect(1.0)
                .animation(.easeInOut, value: 1.0)
            }
        }
    }
}

func signIn() async -> User? {
    guard let clientID = FirebaseApp.app()?.options.clientID else { return nil }
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config
    
    guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = await windowScene.windows.first,
          let rootViewController = await window.rootViewController else {
        print("There is no root view controller")
        return nil
    }
    
    do {
        let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        let user = userAuthentication.user
        guard let idToken = user.idToken else {
            return nil
        }
        let accessToken = user.accessToken
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
        
        let result = try await Auth.auth().signIn(with: credential)
        let firebaseUser = result.user
        return User(
            name: firebaseUser.displayName ?? "",
            email: firebaseUser.email ?? "",
            image: firebaseUser.photoURL?.absoluteString ?? ""
        )
    }
    catch {
        print(error.localizedDescription)
        return nil
    }
}

#Preview {
    ContentView()
}
