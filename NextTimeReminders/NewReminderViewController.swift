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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(NewReminderViewController.cancelButtonTapped))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func newReminderButtonTapped(sender: UIButton) {
        if sender.tag == 0 {
            let locationReminderViewController = LocationReminderViewController(nibName: "LocationReminderViewController", bundle: nil)
            self.navigationController?.pushViewController(locationReminderViewController, animated: true)
        } else {
            let friendReminderViewController = FriendReminderViewController(nibName: "FriendReminderViewController", bundle: nil)
            self.navigationController?.pushViewController(friendReminderViewController, animated: true)
        }
    }
    
    func cancelButtonTapped() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

}
