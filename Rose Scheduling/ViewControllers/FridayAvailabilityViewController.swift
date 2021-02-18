//
//  FridayAvailabilityViewController.swift
//  Rose Scheduling
//
//  Created by Keith on 2/4/21.
//

import UIKit
import FirebaseAuth

class FridayAvailabilityViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var tableController: AvailabilityTableController!
    
    override func viewDidLoad() {
        tableController = AvailabilityTableController(day: .friday)
        tableView.dataSource = tableController
        tableView.delegate = tableController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserManager.shared.beginListening(uid: Auth.auth().currentUser!.uid) {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserManager.shared.stopListening()
    }
}
