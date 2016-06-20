//
//  ReminderViewController.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-20.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the navigation bar
        self.title = "Reminders"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .Plain, target: self, action: #selector(ReminderViewController.logOutButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .Plain, target: self, action: #selector(ReminderViewController.newReminderButtonTapped))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logOutButtonTapped() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.navigateToLoggedOutViewController()
    }
    
    func newReminderButtonTapped() {
        let newReminderViewController = NewReminderViewController(nibName: "NewReminderViewController", bundle: nil)
        let newReminderNavigationController = UINavigationController(rootViewController: newReminderViewController)
        self.navigationController?.presentViewController(newReminderNavigationController, animated: true, completion: nil)
    }

}
