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
    var body: some View {
        VStack {
            
            Button(
                action: {
                    guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                    let config = GIDConfiguration(clientID: clientID)
                    GIDSignIn.sharedInstance.configuration = config
                    
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let window = windowScene.windows.first,
                          let rootViewController = window.rootViewController else {
                        print("There is no root view controller")
                        return
                    }
                    
                    Task {
                        do {
                            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
                            let user = userAuthentication.user
                            guard let idToken = user.idToken else {
                                return
                            }
                            let accessToken = user.accessToken
                            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
                            
                            let result = try await Auth.auth().signIn(with: credential)
                            let firebaseUser = result.user
                            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
                        }
                        catch {
                            print(error.localizedDescription)
                        }
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
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
