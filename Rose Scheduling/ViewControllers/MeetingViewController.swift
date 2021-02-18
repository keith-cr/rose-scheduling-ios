//
//  MeetingViewController.swift
//  Rose Scheduling
//
//  Created by Keith on 2/8/21.
//

import UIKit
import Parchment

class MeetingViewController: UIViewController, PagingViewControllerDataSource {
    var meetingId: String!
    var pagingViewController: PagingViewController!
    
    @IBOutlet weak var meetingTitleButton: UIButton!
    @IBOutlet weak var meetingMembersLabel: UILabel!
    @IBOutlet weak var meetingMembersLabelView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pagingViewController = PagingViewController()
        pagingViewController.dataSource = self

        pagingViewController.indicatorColor = ColorUtils.hexStringToUIColor(hex: "800E00")
        pagingViewController.selectedTextColor = ColorUtils.hexStringToUIColor(hex: "800E00")

        pagingViewController.didMove(toParent: self)
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingViewController.view.topAnchor.constraint(equalTo: meetingMembersLabelView.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MeetingManager.shared.beginListening(meetingID: meetingId) {
            self.meetingTitleButton.setTitle(MeetingManager.shared.meeting.name, for: .normal)
            self.meetingMembersLabel.text = MeetingManager.shared.meeting.getMemberNames()
        }
    }
    
    @IBAction func pressedMeetingTitle(_ sender: Any) {
        let alertController = UIAlertController(title: "Set Meeting Name", message: "", preferredStyle: .alert)
        // Configure
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.text = MeetingManager.shared.meeting.name
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let submitAction = UIAlertAction(title: "Update", style: .default) { (action) in
            let nameTextField = alertController.textFields![0] as UITextField
            MeetingManager.shared.setName(nameTextField.text!)
        }
        alertController.addAction(submitAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return 7
    }

    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let meetingDayViewController = storyboard.instantiateViewController(withIdentifier: "MeetingDayViewController") as! MeetingDayViewController
        meetingDayViewController.meetingID = meetingId
        switch index {
        case 0:
            meetingDayViewController.day = .sunday
        case 1:
            meetingDayViewController.day = .monday
        case 2:
            meetingDayViewController.day = .tuesday
        case 3:
            meetingDayViewController.day = .wednesday
        case 4:
            meetingDayViewController.day = .thursday
        case 5:
            meetingDayViewController.day = .friday
        default:
            meetingDayViewController.day = .saturday
        }
        return meetingDayViewController
    }

    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        var dayTitle = ""
        switch index {
        case 0:
            dayTitle = "Sunday"
        case 1:
            dayTitle = "Monday"
        case 2:
            dayTitle = "Tuesday"
        case 3:
            dayTitle = "Wednesday"
        case 4:
            dayTitle = "Thursday"
        case 5:
            dayTitle = "Friday"
        default:
            dayTitle = "Saturday"
        }
        return PagingIndexItem(index: index, title: dayTitle)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMembersSegue" {
            (segue.destination as! MembersTableViewController).meetingId = meetingId
        }
    }
}
