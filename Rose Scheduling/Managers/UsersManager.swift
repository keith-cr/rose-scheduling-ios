//
//  UsersManager.swift
//  Rose Scheduling
//
//  Created by Keith on 2/14/21.
//

import Foundation
import FirebaseFirestore

class UsersManager {
    var _listener: ListenerRegistration!
    var users: [UserModel] = []
    var _usersCollectionRef: CollectionReference
    static var shared: UsersManager = UsersManager()
    
    init () {
        _usersCollectionRef = Firestore.firestore().collection(kCollectionUsers);
    }
    
    func beginListening(memberIds: [String], changeListener: (() -> Void)?) {
        _listener = _usersCollectionRef.whereField(FieldPath.documentID(), in: memberIds).addSnapshotListener({ (querySnapshot, error) in
            self.users.removeAll()
            querySnapshot?.documents.forEach({ (queryDocumentSnapshot) in
                if (queryDocumentSnapshot.exists) {
                    let user = UserModel(documentSnapshot: queryDocumentSnapshot)
                    self.users.append(user)
                }
            })
        })
    }
    
    func stopListening() {
        _listener.remove()
    }
}
