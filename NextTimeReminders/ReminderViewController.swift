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

class ReminderViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the navigation bar
        self.title = "Reminders"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .Plain, target: self, action: #selector(ReminderViewController.logOutButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .Plain, target: self, action: #selector(ReminderViewController.newReminderButtonTapped))
        self.mapView.showsUserLocation = true
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logOutButtonTapped() {
        FBSDKLoginManager().logOut()
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.navigateToLoggedOutViewController()
    }
    
    func newReminderButtonTapped() {
        let newReminderViewController = NewReminderViewController(nibName: "NewReminderViewController", bundle: nil)
        let newReminderNavigationController = UINavigationController(rootViewController: newReminderViewController)
        self.navigationController?.presentViewController(newReminderNavigationController, animated: true, completion: nil)
    }

}
