//
//  UserManager.swift
//  Rose Scheduling
//
//  Created by Keith on 2/1/21.
//

import Foundation
import Firebase

let kCollectionUsers = "Users"
let kKeyInitials = "initials"
let kKeyName = "name"
let kKeyEmail = "email"
let kKeyLastUpdated = "lastUpdated"
let kKeySunday = "sunday"
let kKeyMonday = "monday"
let kKeyTuesday = "tuesday"
let kKeyWednesday = "wednesday"
let kKeyThursday = "thursday"
let kKeyFriday = "friday"
let kKeySaturday = "saturday"
let kKeySeenTutorial = "seenTutorial"

enum Day {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}

class UserManager {
    var _collectionRef: CollectionReference
    var _document: DocumentSnapshot?
    var _userListener: ListenerRegistration?
    
    static let shared = UserManager()
    private init() {
        _collectionRef = Firestore.firestore().collection(kCollectionUsers)
    }
        
    // Create
    func addNewUserMaybe(uid: String, name: String?, email: String) {
        // Get the user to see if they exist
        // Add the user ONLY if they don't exist
        let userRef = _collectionRef.document(uid)
        userRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error getting user: \(error)")
                return
            }
            if let documentSnapshot = documentSnapshot {
                if documentSnapshot.exists {
                    return
                } else {
                    var initials = ""
                    if let name = name {
                        initials = name.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
                    }
                    userRef.setData([
                        kKeyName: name ?? "",
                        kKeyInitials: initials,
                        kKeyEmail: email,
                        kKeyLastUpdated: Timestamp.init(),
                        kKeySunday: Array.init(repeating: false, count: 16),
                        kKeyMonday: Array.init(repeating: false, count: 16),
                        kKeyTuesday: Array.init(repeating: false, count: 16),
                        kKeyWednesday: Array.init(repeating: false, count: 16),
                        kKeyThursday: Array.init(repeating: false, count: 16),
                        kKeyFriday: Array.init(repeating: false, count: 16),
                        kKeySaturday: Array.init(repeating: false, count: 16),
                        kKeySeenTutorial: false
                    ])
                }
            }
        }
    }
    
    // Read
    func beginListening(uid: String, changeListener: (() -> Void)?) {
        stopListening()
        let userRef = _collectionRef.document(uid)
        _userListener = userRef.addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("Error listening for user: \(error)")
                return
            }
            if let documentSnapshot = documentSnapshot {
                self._document = documentSnapshot
                changeListener?()
            }
        }
    }
    
    func stopListening() {
        _userListener?.remove()
    }
    
    // Update
    func updateName(name: String) {
        let userRef = _collectionRef.document(Auth.auth().currentUser!.uid)
        userRef.updateData([
            kKeyName: name,
        ])
    }
    
    func updateSeenTutorial(seen: Bool) {
        let userRef = _collectionRef.document(Auth.auth().currentUser!.uid)
        userRef.updateData([
            kKeySeenTutorial: seen,
        ])
    }
    
    func updateAvailablity(day: Day, time: Int, value: Bool) {
        let userRef = _collectionRef.document(Auth.auth().currentUser!.uid)
        var key = kKeySunday
        switch day {
        case .sunday:
            key = kKeySunday
        case .monday:
            key = kKeyMonday
        case .tuesday:
            key = kKeyTuesday
        case .wednesday:
            key = kKeyWednesday
        case .thursday:
            key = kKeyThursday
        case .friday:
            key = kKeyFriday
        case .saturday:
            key = kKeySaturday
        }
        if var dayAvail = _document?.get(key) as? [Bool] {
            dayAvail[time] = value
            userRef.updateData([
                key: dayAvail,
            ])
        }
    }
    
    func toggleAvailablity(day: Day, time: Int) {
        let userRef = _collectionRef.document(Auth.auth().currentUser!.uid)
        var key = kKeySunday
        switch day {
        case .sunday:
            key = kKeySunday
        case .monday:
            key = kKeyMonday
        case .tuesday:
            key = kKeyTuesday
        case .wednesday:
            key = kKeyWednesday
        case .thursday:
            key = kKeyThursday
        case .friday:
            key = kKeyFriday
        case .saturday:
            key = kKeySaturday
        }
        if var dayAvail = _document?.get(key) as? [Bool] {
            dayAvail[time] = !dayAvail[time]
            userRef.updateData([
                key: dayAvail,
            ])
        }
    }
    
    func getAvailablity(day: Day, time: Int) -> Bool {
        var key = kKeySunday
        switch day {
        case .sunday:
            key = kKeySunday
        case .monday:
            key = kKeyMonday
        case .tuesday:
            key = kKeyTuesday
        case .wednesday:
            key = kKeyWednesday
        case .thursday:
            key = kKeyThursday
        case .friday:
            key = kKeyFriday
        case .saturday:
            key = kKeySaturday
        }
        if let dayAvail = _document?.get(key) as? [Bool] {
            return dayAvail[time]
        }
        return false
    }
    
    // Delete - There is no delete?
    
    // Getters
    var name: String {
        if let value = _document?.get(kKeyName) {
            return value as! String
        }
        return ""
    }
    
    var seenTutorial: Bool {
        if let value = _document?.get(kKeySeenTutorial) {
            return value as! Bool
        }
        return false
    }
}

