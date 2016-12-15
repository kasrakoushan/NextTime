//
//  FriendReminderViewController.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-20.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import UIKit

class FriendReminderViewController: UIViewController {
    
    

    @IBOutlet var friendsDescriptionLabel: UILabel!
    @IBOutlet var reminderDescriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up the navigation bar
        self.title = "Friend Reminder"
        self.navigationItem.leftBarButtonItem = Helper.generateBarButtonWithImage(imageName: "back", action: #selector(FriendReminderViewController.backButtonTapped), target: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // back button
    func backButtonTapped() {
        // pop back to the new reminder view controller
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        print("new friend reminder created")
    }
    
    @IBAction func findFriendsButtonFound(_ sender: UIButton) {
    }
}
