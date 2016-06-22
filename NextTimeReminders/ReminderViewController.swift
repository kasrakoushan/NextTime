//
//  ReminderViewController.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-20.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import MapKit
import Firebase

class ReminderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the navigation bar
        self.title = "Reminders"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .Plain, target: self, action: #selector(ReminderViewController.logOutButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .Plain, target: self, action: #selector(ReminderViewController.newReminderButtonTapped))
        self.mapView.showsUserLocation = true
        
        // table
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // print current log in status
        let token = FBSDKAccessToken.currentAccessToken()
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name"], tokenString: token.tokenString, version: nil, HTTPMethod: "GET")
        request.startWithCompletionHandler() {(connection, result, error) in
            if error == nil {
                if let name = result["first_name"] {
                    self.title = "\(name!)'s Reminders"
                }
            } else {
                print("Error in current user's name request from ReminderViewController: \(error)")
            }
            
        }
        
        // reload the table
        self.tableView.reloadData()
        
        // check on reminder list
        print("\(ReminderController.sharedInstance.reminders)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logOutButtonTapped() {
        // do we need to sign out of Facebook and Firebase? probably yes
        FBSDKLoginManager().logOut()
        try! FIRAuth.auth()!.signOut()
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.navigateToLoggedOutViewController()
    }
    
    func newReminderButtonTapped() {
        let newReminderViewController = NewReminderViewController(nibName: "NewReminderViewController", bundle: nil)
        let newReminderNavigationController = UINavigationController(rootViewController: newReminderViewController)
        self.navigationController?.presentViewController(newReminderNavigationController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // just one section
        // maybe eventually, divide into friend and location sections
        return ReminderController.sharedInstance.reminders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = ReminderController.sharedInstance.reminders[indexPath.row].reminderDescription
        
        return cell
    }

}
