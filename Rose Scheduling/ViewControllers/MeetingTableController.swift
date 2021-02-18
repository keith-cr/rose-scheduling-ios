//
//  MeetingTableController.swift
//  Rose Scheduling
//
//  Created by Keith on 2/8/21.
//

import UIKit
import FirebaseAuth

class MeetingTableController: NSObject, UITableViewDataSource {
    var day: Day
    var meetingManager: MeetingManager
    
    init (day: Day, meetingManager: MeetingManager) {
        self.day = day
        self.meetingManager = meetingManager
    }
    
    let times: [String] = ["8:00 - 9:00 AM", "9:00 - 10:00 AM", "10:00 - 11:00 AM", "11:00 AM - 12:00 PM", "12:00 - 1:00 PM", "1:00 - 2:00 PM", "2:00 - 3:00 PM", "3:00 - 4:00 PM", "4:00 - 5:00 PM", "5:00 - 6:00 PM", "6:00 - 7:00 PM", "7:00 - 8:00 PM", "8:00 - 9:00 PM", "9:00 - 10:00 PM", "10:00 - 11:00 PM", "11:00 PM - 12:00 AM"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingAvailabilityCell", for: indexPath) as!
            MeetingAvailabilityCell

        var hexColor = "27AE60"
        
        cell.timeLabel.text = times[indexPath.row]
        
        if meetingManager.meeting != nil {
            cell.availabilityLabel.text = String(meetingManager.meeting.getCountForTimeslot(day: day, timeslot: indexPath.row)) + "/" + String(meetingManager.meeting.members.count)
            cell.availableMembersLabel.text = meetingManager.meeting.getUserInitialsForTimeslot(day: day, timeslot: indexPath.row)
            let membersAvailable = Double(meetingManager.meeting.getCountForTimeslot(day: day, timeslot: indexPath.row))
            let totalMembers = Double(meetingManager.meeting.members.count)
            let totalAvailable = membersAvailable / totalMembers
            if (totalAvailable == 0) {
                hexColor = "EC4C4C"
            } else if (totalAvailable < 0.5) {
                hexColor = "F2994A"
            } else if (totalAvailable < 0.75) {
                hexColor = "F2C94C"
            }
        }
        
        cell.contentView.layer.backgroundColor = ColorUtils.hexStringToUIColor(hex: hexColor).cgColor
            
        return cell
    }
}

