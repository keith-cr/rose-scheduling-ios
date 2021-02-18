//
//  UserSearchController.swift
//  Rose Scheduling
//
//  Created by Keith on 2/14/21.
//

import Foundation
import FirebaseFirestore

class UserSearchManager {
    var _listener: ListenerRegistration!
    var users: [UserModel] = []
    var _usersCollectionRef: CollectionReference
    static var shared: UserSearchManager = UserSearchManager()
    
    init () {
        _usersCollectionRef = Firestore.firestore().collection(kCollectionUsers);
    }
    
    func beginListening(searchString: String, changeListener: (() -> Void)?) {
        _listener = _usersCollectionRef.order(by: "name").whereField("name", isGreaterThanOrEqualTo: searchString).whereField("name", isLessThanOrEqualTo: searchString+"\u{f8ff}").addSnapshotListener({ (querySnapshot, error) in
            self.users.removeAll()
            querySnapshot?.documents.forEach({ (queryDocumentSnapshot) in
                if (queryDocumentSnapshot.exists) {
                    let user = UserModel(documentSnapshot: queryDocumentSnapshot)
                    self.users.append(user)
                }
            })
            if let changeListener = changeListener {
                changeListener()
            }
        })
    }
    
    func stopListening() {
        if let listener = _listener {
            listener.remove()
        }
        users.removeAll()
    }
}

