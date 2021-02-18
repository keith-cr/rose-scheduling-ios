//
//  AvailabilityTabBarController.swift
//  Rose Scheduling
//
//  Created by Keith on 2/4/21.
//

import SwipeableTabBarController

class AvailabilityTabBarController: SwipeableTabBarController {
    override func viewWillAppear(_ animated: Bool) {
        self.tabBar.tintColor = ColorUtils.hexStringToUIColor(hex: "800E00")
        let systemFontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)]
        UITabBarItem.appearance().setTitleTextAttributes(systemFontAttributes, for: .normal)
    }
}
