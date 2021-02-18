//
//  AvailabilityViewController.swift
//  Rose Scheduling
//
//  Created by Keith on 2/7/21.
//

import UIKit
import Parchment

class AvailabilityViewController: UIViewController, PagingViewControllerDataSource {
  override func viewDidLoad() {
    super.viewDidLoad()

    let pagingViewController = PagingViewController()
    pagingViewController.dataSource = self
    
    pagingViewController.indicatorColor = ColorUtils.hexStringToUIColor(hex: "800E00")
    pagingViewController.selectedTextColor = ColorUtils.hexStringToUIColor(hex: "800E00")
    
    addChild(pagingViewController)
    view.addSubview(pagingViewController.view)
    view.constrainToEdges(pagingViewController.view)
    pagingViewController.didMove(toParent: self)
  }
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return 7
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dayAvailabilityViewController = storyboard.instantiateViewController(withIdentifier: "DayAvailabilityViewController") as! DayAvailabilityViewController
        switch index {
        case 0:
            dayAvailabilityViewController.day = .sunday
        case 1:
            dayAvailabilityViewController.day = .monday
        case 2:
            dayAvailabilityViewController.day = .tuesday
        case 3:
            dayAvailabilityViewController.day = .wednesday
        case 4:
            dayAvailabilityViewController.day = .thursday
        case 5:
            dayAvailabilityViewController.day = .friday
        default:
            dayAvailabilityViewController.day = .saturday
        }
        return dayAvailabilityViewController
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
}

