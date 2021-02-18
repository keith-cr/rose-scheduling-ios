//
//  MeetingManager.swift
//  Rose Scheduling
//
//  Created by Keith on 2/8/21.
//

import Foundation
import FirebaseFirestore

class MeetingManager {
    var _meetingListener: ListenerRegistration!
    var meeting: Meeting!
    static var shared: MeetingManager = MeetingManager()
    
    func beginListening(meetingID: String, changeListener: (() -> Void)?) {
        let query = Firestore.firestore().collection(kCollectionMeetings).document(meetingID);
        _meetingListener = query.addSnapshotListener({ (documentSnapshot, error) in
            if let error = error {
                print("Error getting meeting \(error)")
                return
            }
            self.meeting = Meeting(documentSnapshot: documentSnapshot!)
            self.meeting.beginListening {
                if let changeListener = changeListener {
                    changeListener()
                }
            }
        })
    }
    
    func setName(_ name: String) {
        Firestore.firestore().collection(kCollectionMeetings).document(meeting.id).updateData([
            "name": name
        ])
    }
    
    func stopListening() {
        meeting.stopListening()
    }
}
