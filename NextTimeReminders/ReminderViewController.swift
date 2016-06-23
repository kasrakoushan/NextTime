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
import SWTableViewCell

class ReminderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate {
    
    @IBOutlet var reminderTableView: UITableView!
    @IBOutlet var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the navigation bar
        self.title = "Reminders"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .Plain, target: self, action: #selector(ReminderViewController.logOutButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .Plain, target: self, action: #selector(ReminderViewController.newReminderButtonTapped))
        self.mapView.showsUserLocation = true
        
        // table
        self.reminderTableView.delegate = self
        self.reminderTableView.dataSource = self
        
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
        self.reminderTableView.reloadData()
        
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
    
    // ---------------------- TableView functions ----------------------
    
    // return number of reminders
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // just one section
        // maybe eventually, divide into friend and location sections
        return ReminderController.sharedInstance.reminders.count
    }
    
    // return the cell at the given row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var cell: SWTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? SWTableViewCell
        if cell == nil {
            cell = SWTableViewCell(style: .Value1, reuseIdentifier: cellIdentifier)
            cell.rightUtilityButtons = self.getRightUtilityButtons()
            cell.leftUtilityButtons = self.getLeftUtilityButtons()
            cell.delegate = self
        }
        cell.textLabel?.text = ReminderController.sharedInstance.reminders[indexPath.row].reminderDescription
        if ReminderController.sharedInstance.reminders[indexPath.row].state == ReminderState.Active {
            cell.detailTextLabel?.text = "Nearby"
            cell.detailTextLabel?.textColor = UIColor.redColor()
        } else {
            cell.detailTextLabel?.text = "Saved"
            cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let annotations = ReminderController.sharedInstance.reminders[indexPath.row].annotations,
            region = ReminderController.sharedInstance.reminders[indexPath.row].region {
            // reminder type is location
            let viewController = UIViewController()
            let map = MKMapView(frame: viewController.view.bounds)
            viewController.view.addSubview(map)
            map.addAnnotations(annotations)
            map.setRegion(region, animated: true)
            map.showsUserLocation = true
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
    }
    
    // ---------------------- SW Cell Functions ----------------------
    
    // helper function for SW table cell
    func getRightUtilityButtons() -> [AnyObject] {
        let rightUtilityButtons = NSMutableArray()
        rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor.whiteColor(), icon: UIImage(named: "edit_button"))
        return rightUtilityButtons as [AnyObject]
    }
    
    // helper function for SW table cell
    func getLeftUtilityButtons() -> [AnyObject] {
        let leftUtilityButtons = NSMutableArray()
        leftUtilityButtons.sw_addUtilityButtonWithColor(UIColor.whiteColor(), icon: UIImage(named: "complete_button"))
        return leftUtilityButtons as [AnyObject]
    }
    
    // SWTableViewCellDelegate function
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex index: Int) {
        // complete button
        if let indexPath = self.reminderTableView.indexPathForCell(cell) {
            ReminderController.sharedInstance.reminders.removeAtIndex(indexPath.row)
            self.reminderTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        } else {
            // the index path is somehow invalid
            print("delete cell: cell is not in the table")
        }
    }
    
    // SWTableViewCellDelegate function
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        // edit button
        if let indexPath = self.reminderTableView.indexPathForCell(cell) {
            // open the location reminder view controller with edit state
            print(indexPath.row)
        }
    }
    
    

}
