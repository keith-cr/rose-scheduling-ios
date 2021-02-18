//
//  Meeting.swift
//  Rose Scheduling
//
//  Created by Keith on 2/8/21.
//

import Foundation
import FirebaseFirestore

class Meeting {
    var id: String
    var name: String
    var memberIds: [String]
    var members: [UserModel]
    var _userListener: ListenerRegistration!
    
    init(documentSnapshot: DocumentSnapshot) {
        id = documentSnapshot.documentID
        let data = documentSnapshot.data()
        if (documentSnapshot.exists) {
            name = data!["name"] as! String
            memberIds = data!["members"] as! [String]
            members = []
        } else {
            name = ""
            memberIds = []
            members = []
        }
    }
    
    func beginListening(changeListener: (() -> Void)?) {
        if memberIds.count != 0 {
            _userListener = Firestore.firestore().collection(kCollectionUsers).whereField(FieldPath.documentID(), in: memberIds).addSnapshotListener({ (querySnapshot, error) in
                if let error = error {
                    print("Error getting meeting users \(error)")
                }
                self.members.removeAll()
                querySnapshot?.documents.forEach({ (queryDocumentSnapshot) in
                    self.members.append(UserModel(documentSnapshot: queryDocumentSnapshot))
                    if let changeListener = changeListener {
                        changeListener()
                    }
                })
            })
        }
    }
    
    func stopListening() {
        _userListener.remove()
    }
    
    func getMemberNames() -> String {
        return members.enumerated().reduce("") { (accum, curr) -> String in
            return accum + curr.1.name + (curr.0 == members.count - 1 ? "" : ", ")
        }
    }
    
    func getCountForTimeslot(day: Day, timeslot: Int) -> Int {
        var count = 0
        members.forEach { (user) in
            if user.getAvailablity(day: day, time: timeslot) {
                count += 1
            }
        }
        return count
    }
        
    func getUserInitialsForTimeslot(day: Day, timeslot: Int) -> String {
        var initials: [String] = []
        members.forEach { (user) in
            if user.getAvailablity(day: day, time: timeslot) {
                initials.append(user.initials)
            }
        }
        return initials.enumerated().reduce("") { (accum, curr) -> String in
            return accum + curr.1 + (curr.0 == initials.count - 1 ? "" : ", ")
        }
    }
}
