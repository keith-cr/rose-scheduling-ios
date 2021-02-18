//
//  AvailabilityViewController.swift
//  Rose Scheduling
//
//  Created by Keith on 2/2/21.
//

import UIKit
import FirebaseAuth

class AvailabilityTableController: NSObject, UITableViewDataSource, UITableViewDelegate {
    var day: Day
    
    init (day: Day) {
        self.day = day
    }
    
    let times: [String] = ["8:00 - 9:00 AM", "9:00 - 10:00 AM", "10:00 - 11:00 AM", "11:00 AM - 12:00 PM", "12:00 - 1:00 PM", "1:00 - 2:00 PM", "2:00 - 3:00 PM", "3:00 - 4:00 PM", "4:00 - 5:00 PM", "5:00 - 6:00 PM", "6:00 - 7:00 PM", "7:00 - 8:00 PM", "8:00 - 9:00 PM", "9:00 - 10:00 PM", "10:00 - 11:00 PM", "11:00 PM - 12:00 AM"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AvailabilityCell", for: indexPath) as! AvailabilityCell
                
        let avail = UserManager.shared.getAvailablity(day: day, time: indexPath.row)
        
        let hexColor = avail ? "27AE60" : "EC4C4C"
        cell.contentView.layer.backgroundColor = ColorUtils.hexStringToUIColor(hex: hexColor).cgColor
        
        cell.availabilityLabel.text = avail ? "Available" : "Unavailable"
        cell.timeLabel.text = times[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserManager.shared.toggleAvailablity(day: day, time: indexPath.row)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
