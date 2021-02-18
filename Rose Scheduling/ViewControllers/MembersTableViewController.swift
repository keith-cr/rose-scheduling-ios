//
//  MembersViewController.swift
//  Rose Scheduling
//
//  Created by Keith on 2/14/21.
//

import UIKit
import FirebaseFirestore

class MembersTableViewController: UITableViewController {
    var meetingId: String!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MeetingManager.shared.beginListening(meetingID: meetingId) {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MeetingManager.shared.stopListening()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MeetingManager.shared.meeting.members.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath)
        cell.textLabel?.text = MeetingManager.shared.meeting.members[indexPath.row].name
        cell.detailTextLabel?.text = MeetingManager.shared.meeting.members[indexPath.row].email
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let userToDelete = MeetingManager.shared.meeting.members[indexPath.row]
            var memberIds = MeetingManager.shared.meeting.memberIds
            memberIds.removeAll { (str) -> Bool in
                str == userToDelete.id
            }
            Firestore.firestore().collection(kCollectionMeetings).document(MeetingManager.shared.meeting.id).updateData([
                "members": memberIds
            ])
            if (userToDelete.id == AuthManager.shared.currentUser!.uid) {
                guard let viewControllers = self.navigationController?.viewControllers else {
                    return
                }

                for firstViewController in viewControllers {
                    if firstViewController is MeetingsViewController {
                        self.navigationController?.popToViewController(firstViewController, animated: true)
                        break
                    }
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMemberSearchSegue" {
            (segue.destination as! MemberSearchViewController).meetingId = meetingId
        }
    }
}
