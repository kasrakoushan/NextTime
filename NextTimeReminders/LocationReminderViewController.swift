//
//  LocationReminderViewController.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-20.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import UIKit

class LocationReminderViewController: UIViewController {
    
    
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var reminderDescriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Location Reminder"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(LocationReminderViewController.backButtonTapped))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func backButtonTapped() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func addButtonTapped(sender: UIButton) {
        print("new location reminder created")
    }

}
