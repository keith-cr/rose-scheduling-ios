//
//  MeetingDayViewController.swift
//  Rose Scheduling
//
//  Created by Keith on 2/8/21.
//

import UIKit
import FirebaseAuth

class MeetingDayViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var meetingManager: MeetingManager = MeetingManager()
    var tableController: MeetingTableController!
    var day: Day!
    var meetingID: String!
        
    override func viewDidLoad() {
        tableController = MeetingTableController(day: day, meetingManager: meetingManager)
        tableView.dataSource = tableController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        meetingManager.beginListening(meetingID: meetingID) {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        MeetingManager.shared.stopListening()
    }
}
