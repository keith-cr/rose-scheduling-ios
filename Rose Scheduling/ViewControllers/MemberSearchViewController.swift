//
//  MemberSearchViewController.swift
//  Rose Scheduling
//
//  Created by Keith on 2/14/21.
//

import UIKit
import FirebaseFirestore

class MemberSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UserSearchCellDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var meetingId: String!
    
    override func viewDidLoad() {
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        tableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        MeetingManager.shared.stopListening()
        UserSearchManager.shared.stopListening()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        UserSearchManager.shared.stopListening()
        MeetingManager.shared.beginListening(meetingID: meetingId) {
            UserSearchManager.shared.beginListening(searchString: searchBar.text!) {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserSearchManager.shared.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchCell", for: indexPath) as! UserSearchCell
        cell.nameLabel.text = UserSearchManager.shared.users[indexPath.row].name
        cell.emailLabel.text = UserSearchManager.shared.users[indexPath.row].email
        cell.addButton.tag = indexPath.row
        cell.delegate = self
        if (MeetingManager.shared.meeting.memberIds.contains(UserSearchManager.shared.users[indexPath.row].id)) {
            cell.addButton.isHidden = true
        } else {
            cell.addButton.isHidden = false
        }
        return cell
    }
    
    func didTapButtonInCell(_ row: Int) {
        let userId = UserSearchManager.shared.users[row].id
        if (!MeetingManager.shared.meeting.memberIds.contains(userId)) {
            var memberIds = MeetingManager.shared.meeting.memberIds
            memberIds.append(userId)
            Firestore.firestore().collection(kCollectionMeetings).document(meetingId).updateData([
                "members": memberIds.uniques
            ])
            navigationController?.popViewController(animated: true)
        }
    }
}

class UserSearchCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    weak var delegate: UserSearchCellDelegate?
    
    @IBAction func didTapButton(sender: UIButton) {
        delegate?.didTapButtonInCell(sender.tag)
    }
}

protocol UserSearchCellDelegate: class {
    func didTapButtonInCell(_ row: Int)
}
