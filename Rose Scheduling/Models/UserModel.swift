//
//  User.swift
//  Rose Scheduling
//
//  Created by Keith on 2/8/21.
//

import Foundation
import FirebaseFirestore

class UserModel {
    var id: String
    var name: String
    var email: String
    var sunday: [Bool]
    var monday: [Bool]
    var tuesday: [Bool]
    var wednesday: [Bool]
    var thursday: [Bool]
    var friday: [Bool]
    var saturday: [Bool]
    var initials: String
    
    init (documentSnapshot: DocumentSnapshot) {
        id = documentSnapshot.documentID
        if let data = documentSnapshot.data() {
            name = data[kKeyName] as? String ?? ""
            email = data[kKeyEmail] as? String ?? ""
            sunday = data[kKeySunday] as? [Bool] ?? []
            monday = data[kKeyMonday] as? [Bool] ?? []
            tuesday = data[kKeyTuesday] as? [Bool] ?? []
            wednesday = data[kKeyWednesday] as? [Bool] ?? []
            thursday = data[kKeyThursday] as? [Bool] ?? []
            friday = data[kKeyFriday] as? [Bool] ?? []
            saturday = data[kKeySaturday] as? [Bool] ?? []
            initials = data[kKeyInitials] as? String ?? ""
        } else {
            name = ""
            email = ""
            sunday = []
            monday = []
            tuesday = []
            wednesday = []
            thursday = []
            friday = []
            saturday = []
            initials = ""
        }
    }
    
    func getAvailablity(day: Day, time: Int) -> Bool {
        switch day {
        case .sunday:
            return sunday[time]
        case .monday:
            return monday[time]
        case .tuesday:
            return tuesday[time]
        case .wednesday:
            return wednesday[time]
        case .thursday:
            return thursday[time]
        case .friday:
            return friday[time]
        case .saturday:
            return saturday[time]
        }
    }
}
