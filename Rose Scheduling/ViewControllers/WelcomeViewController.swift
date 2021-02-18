//
//  WelcomeViewController.swift
//  Rose Scheduling
//
//  Created by Keith on 2/1/21.
//

import UIKit

class WelcomeViewController: UIViewController {
    let kShowMeetingsSegueIdentifier = "ShowMeetingsSegue"
    let kShowImportSegueIdentifier = "ShowImportSegue"
    @IBAction func getStartedButtonPressed(_ sender: Any) {
        AuthManager.shared.signInWithRosefire(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AuthManager.shared.beginListening { _, _ in
            if AuthManager.shared.currentUser != nil {
                UserManager.shared.beginListening(uid: AuthManager.shared.currentUser!.uid) {
                    if (UserManager.shared.seenTutorial) {
                        UserManager.shared.stopListening()
                        self.performSegue(withIdentifier: self.kShowMeetingsSegueIdentifier, sender: self)
                    } else {
                        self.performSegue(withIdentifier: self.kShowImportSegueIdentifier, sender: self)
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AuthManager.shared.stopListening()
        UserManager.shared.stopListening()
    }
}
