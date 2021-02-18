//
//  GroupsViewController.swift
//  Rose Scheduling
//
//  Created by Keith on 2/2/21.
//

import UIKit

class MeetingsViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editScheduleButton: UIButton!
    
    var newMeetingID: String!
    
    override func viewDidLoad() {
        let px = 1 / UIScreen.main.scale
        let frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: px)
        let line = UIView(frame: frame)
        self.tableView.tableHeaderView = line
        line.backgroundColor = self.tableView.separatorColor
        editScheduleButton.layer.borderColor = ColorUtils.hexStringToUIColor(hex: "#800E00").cgColor
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(pressedEditButton))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AuthManager.shared.beginListening { _, _ in
            if AuthManager.shared.currentUser == nil {
                guard let viewControllers = self.navigationController?.viewControllers else {
                    return
                }

                for firstViewController in viewControllers {
                    if firstViewController is WelcomeViewController {
                        self.navigationController?.popToViewController(firstViewController, animated: true)
                        break
                    }
                }
            } else {
                MeetingsManager.shared.beginListening {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        MeetingsManager.shared.stopListening()
    }
    
    @objc func pressedEditButton() {
        tableView.setEditing(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(pressedDoneButton))
    }
    
    @objc func pressedDoneButton() {
        tableView.setEditing(false, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(pressedEditButton))
    }
    
    @IBAction func pressedSignOut(_ sender: Any) {
        AuthManager.shared.signOut()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MeetingsManager.shared.meetings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingCell", for: indexPath)
                
        let meeting = MeetingsManager.shared.meetings[indexPath.row]
        cell.textLabel?.text = meeting.name
        cell.detailTextLabel?.text = meeting.getMemberNames()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            MeetingsManager.shared.deleteMeeting(id: MeetingsManager.shared.meetings[indexPath.row].id, completion: nil)
        }
    }
    
    @IBAction func pressedNewMeetingButton(_ sender: Any) {
        newMeetingID = MeetingsManager.shared.createNewMeeting()
        performSegue(withIdentifier: "ShowMeetingSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMeetingSegue" {
            if newMeetingID != nil {
                (segue.destination as! MeetingViewController).meetingId = newMeetingID
                newMeetingID = nil
            } else if let indexPath = tableView.indexPathForSelectedRow {
                (segue.destination as! MeetingViewController).meetingId = MeetingsManager.shared.meetings[indexPath.row].id
            }
        }
    }
}
