//
//  NewReminderViewController.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-20.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import UIKit

class NewReminderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up navigation bar
        self.title = "New Reminder"
        self.navigationItem.leftBarButtonItem = Helper.generateBarButtonWithImage(imageName: "cancel", action: #selector(NewReminderViewController.cancelButtonTapped), target: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // add a new location or friend reminder
    @IBAction func newReminderButtonTapped(sender: UIButton) {
        if sender.tag == 0 {
            // location reminder
            let locationReminderViewController = LocationReminderViewController(nibName: "LocationReminderViewController", bundle: nil)
            self.navigationController?.pushViewController(locationReminderViewController, animated: true)
        } else {
            // friend reminder
            let friendReminderViewController = FriendReminderViewController(nibName: "FriendReminderViewController", bundle: nil)
            self.navigationController?.pushViewController(friendReminderViewController, animated: true)
        }
    }
    
    // go back to reminder list
    func cancelButtonTapped() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

}
