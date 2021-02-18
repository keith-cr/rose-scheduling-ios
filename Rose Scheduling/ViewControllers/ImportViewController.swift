//
//  ImportViewController.swift
//  Rose Scheduling
//
//  Created by Keith on 2/15/21.
//

import UIKit

class ImportViewController: UIViewController {
    @IBOutlet weak var shareURLButton: UIButton!
    
    @IBAction func btnShare(sender: UIButton)
    {
        let objectsToShare: URL = URL(string: "https://rose-scheduling.web.app/")!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.postToTwitter ]

        self.present(activityViewController, animated: true, completion: nil)
    }

    @IBAction func pressedContinueButton(_ sender: Any) {
        UserManager.shared.updateSeenTutorial(seen: true)
        performSegue(withIdentifier: "ShowMeetingsSegue", sender: self)
    }
    
    override func viewDidLoad() {
        shareURLButton.layer.borderColor = ColorUtils.hexStringToUIColor(hex: "#800E00").cgColor
    }
}
