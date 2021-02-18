//
//  SundayAvailabilityViewController.swift
//  Rose Scheduling
//
//  Created by Keith on 2/4/21.
//

import UIKit
import FirebaseAuth

class DayAvailabilityViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var tableController: AvailabilityTableController!
    var day: Day!
        
    override func viewDidLoad() {
        tableController = AvailabilityTableController(day: day)
        tableView.dataSource = tableController
        tableView.delegate = tableController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserManager.shared.beginListening(uid: Auth.auth().currentUser!.uid) {
            self.tableView.reloadData()
        }
    }
}


