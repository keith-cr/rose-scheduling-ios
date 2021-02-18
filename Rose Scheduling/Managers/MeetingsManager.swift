//
//  MeetingsManager.swift
//  Rose Scheduling
//
//  Created by Keith on 2/8/21.
//

import Foundation
import FirebaseFirestore

let kCollectionMeetings = "Meetings"

class MeetingsManager {
    var _listener: ListenerRegistration!
    var meetings: [Meeting] = []
    var _meetingsCollectionRef: CollectionReference
    static var shared: MeetingsManager = MeetingsManager()
    
    init () {
        _meetingsCollectionRef = Firestore.firestore().collection(kCollectionMeetings);
    }
    
    func beginListening(changeListener: (() -> Void)?) {
        _listener = _meetingsCollectionRef.whereField("members", arrayContains: AuthManager.shared.currentUser!.uid).order(by: "created", descending: true).addSnapshotListener({ (querySnapshot, error) in
            self.meetings.forEach { (meeting) in
                meeting.stopListening()
            }
            self.meetings.removeAll()
            if querySnapshot?.documents.count == 0 {
                if let changeListener = changeListener {
                    changeListener()
                }
            }
            querySnapshot?.documents.forEach({ (queryDocumentSnapshot) in
                if (queryDocumentSnapshot.exists) {
                    let meeting = Meeting(documentSnapshot: queryDocumentSnapshot)
                    meeting.beginListening(changeListener: changeListener)
                    self.meetings.append(meeting)
                }
            })
        })
    }
    
    func stopListening() {
        _listener.remove()
        meetings.forEach { (meeting) in
            meeting.stopListening()
        }
    }
    
    func deleteMeeting(id: String, completion: ((Error?) -> Void)?) {
        _meetingsCollectionRef.document(id).delete(completion: completion)
    }
    
    func createNewMeeting() -> String {
        return _meetingsCollectionRef.addDocument(data: [
            "members": [AuthManager.shared.currentUser!.uid],
            "name": "New Meeting (Tap To Edit)",
            "created": Timestamp.init(),
        ]).documentID
    }
}
