//
//  AuthManager.swift
//  Rose Scheduling
//
//  Created by Keith on 2/1/21.
//

import UIKit
import Rosefire
import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
    let REGISTRY_TOKEN = "b1821bfb-bf42-4f91-bfd1-c3600fdf3c45"
    var listenerHandler: AuthStateDidChangeListenerHandle!
    var currentUser: User?
    
    func signInWithRosefire(delegate: UIViewController, completion: ((AuthDataResult) -> Void)? = nil) {
        Rosefire.sharedDelegate().uiDelegate = delegate // This should be your view controller
        Rosefire.sharedDelegate().signIn(registryToken: REGISTRY_TOKEN) { (err, result) in
            if let err = err {
                    print("Rosefire sign in error! \(err)")
                    return
            }
            Auth.auth().signIn(withCustomToken: result!.token) { (authResult, error) in
                if let error = error {
                    print("Firebase sign in error! \(error)")
                    return
                }
                UserManager.shared.addNewUserMaybe(uid: authResult!.user.uid, name: result!.name, email: result!.email)
                if let completion = completion {
                    completion(authResult!)
                }
            }
        }
    }
    
    func beginListening(changeListener: @escaping ((_ auth: Auth, _ user: User?) -> Void)) {
        listenerHandler = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.currentUser = Auth.auth().currentUser
            changeListener(auth, user)
        }
    }
    
    func stopListening() {
        if let listenerHandler = listenerHandler {
            Auth.auth().removeStateDidChangeListener(listenerHandler)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
        } catch let signOutError {
            print ("Error signing out: %@", signOutError)
        }
    }
}


