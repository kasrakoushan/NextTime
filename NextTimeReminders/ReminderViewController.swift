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
import SWTableViewCell

// The main view controller of the app, displaying all of the reminders in a table
class ReminderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate {
    
    // the table of reminders
    @IBOutlet var reminderTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up the navigation bar, with custom buttons
        self.title = "Reminders"
        self.navigationItem.leftBarButtonItem = Helper.generateBarButtonWithImage(imageName: "logout",
                                                                                  action: #selector(ReminderViewController.logOutButtonTapped),
                                                                                  target: self)
        self.navigationItem.rightBarButtonItem = Helper.generateBarButtonWithImage(imageName: "add_new",
                                                                                   action: #selector(ReminderViewController.newReminderButtonTapped),
                                                                                   target: self)
        
        
        // set up the table's delegate and data source
        self.reminderTableView.delegate = self
        self.reminderTableView.dataSource = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // set the navigation bar title to the user's first name
        // obtain the user's access token
        let token = FBSDKAccessToken.currentAccessToken()
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name"], tokenString: token.tokenString, version: nil, HTTPMethod: "GET")
        // make the graph request
        request.startWithCompletionHandler() {(connection, result, error) in
            // check for errors
            if error == nil {
                if let name = result["first_name"] {
                    self.title = "\(name!)'s Reminders"
                }
            } else {
                // display error message
                print("ReminderList: failed in obtaining current user's name \(error.localizedDescription)")
            }
            
        }
        
        // reload the table
        self.reminderTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // log out of Facebook
    func logOutButtonTapped() {
        // sign out of Facebook
        // QUESTION: do we need to sign out of both?
        FBSDKLoginManager().logOut()
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.navigateToLoggedOutViewController()
    }
    
    // add a new reminder
    func newReminderButtonTapped() {
        // create a view controller for the new reminder page
        let newReminderViewController = NewReminderViewController(nibName: "NewReminderViewController", bundle: nil)
        // create a navigation controller to wrap around the new reminder flow
        let newReminderNavigationController = UINavigationController(rootViewController: newReminderViewController)
        // present the new reminder view
        self.navigationController?.presentViewController(newReminderNavigationController, animated: true, completion: nil)
    }
    
    // ************************** TABLEVIEW FUNCTIONS **************************
    
    // *UITableViewDataSource* function: return number of reminders in the table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TO-DO: eventually divide into separate friend and location sections?
        return ReminderController.sharedInstance.reminders.count
    }
    
    // *UITableViewDataSource* function: return the cell at the given row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        
        // dequeue from existing cells if possible
        var cell: SWTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? SWTableViewCell
        if cell == nil {
            // if no cell was provided, initialize one
            cell = SWTableViewCell(style: .Value1, reuseIdentifier: cellIdentifier)
            cell.rightUtilityButtons = [] // no right utility buttons for now
            cell.leftUtilityButtons = self.getLeftUtilityButtons()
            cell.delegate = self
        }
        
        // set font for the textLabel and detailTextLabel
        cell.textLabel?.font = UIFont(name: "Kohinoor Bangla", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Kohinoor Bangla", size: 16)
        // set the textLabel to the reminder's body
        cell.textLabel?.text = ReminderController.sharedInstance.reminders[indexPath.row].reminderDescription
        
        // set the detailTextLabel to the reminder status (either "Saved" or "Nearby")
        if ReminderController.sharedInstance.reminders[indexPath.row].state == ReminderState.Active {
            cell.detailTextLabel?.text = "Nearby"
            cell.detailTextLabel?.textColor = UIColor.redColor()
        } else {
            cell.detailTextLabel?.text = "Saved"
            cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
        }
        
        return cell
    }
    
    
    // *UITableViewDelegate* function called when selecting a row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // check if the reminder has annotations and a region (i.e. if it is a location reminder)
        if let annotations = ReminderController.sharedInstance.reminders[indexPath.row].annotations,
            region = ReminderController.sharedInstance.reminders[indexPath.row].region {
            // reminder type is location
            
            // generate map that covers the whole screen
            let viewController = UIViewControllerWithCustomBackButton()
            let map = MKMapView(frame: viewController.view.bounds)
            viewController.view.addSubview(map)
            
            // add the reminder's annotations to the map, set the map's type, show current location
            map.addAnnotations(annotations)
            map.mapType = .HybridFlyover
            map.showsUserLocation = true
            
            // check if current location is accessible
            if let currentCoord = (UIApplication.sharedApplication().delegate as? AppDelegate)?.locationManager?.location?.coordinate {
                // set the map's region to show the current location as well
                let currentLocation = MKPointAnnotation()
                currentLocation.coordinate = currentCoord
                // calling the show annotations function will reset the region of the map automatically
                map.showAnnotations(annotations + [currentLocation], animated: true)
                // remove the pin for the current location (instead displayed with blue dot)
                map.removeAnnotation(currentLocation)
            } else {
                // show all of the annotations (region was calculated from original search)
                map.setRegion(region, animated: true)
            }
            
            // present the map view representing the reminder
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
        // if the reminder type is not location, do nothing for now
        // TO-DO: add action for Friend reminders
    }
    
    // *UITableViewDelegate* to determine cell heights
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // somewhat larger than usual
        return 60
    }
    
    // ---------------------- SW Cell Functions ----------------------
    // SWTableViewCell is a custom cell that allows for swiping in both directions with several editing options
    
    // return the utility buttons on the left (only "complete" button for now)
    func getLeftUtilityButtons() -> [AnyObject] {
        let leftUtilityButtons = NSMutableArray()
        leftUtilityButtons.sw_addUtilityButtonWithColor(UIColor.whiteColor(), icon: UIImage(named: "complete_button"))
        return leftUtilityButtons as [AnyObject]
    }
    
    // *SWTableViewCellDelegate* function called when a utility button is tapped
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex index: Int) {
        // complete button has been tapped - remove selected reminder
        
        // get the index of the selected cell
        if let indexPath = self.reminderTableView.indexPathForCell(cell) {
            // remove the reminder from the model
            ReminderController.sharedInstance.reminders.removeAtIndex(indexPath.row)
            // delete the reminder from the table
            self.reminderTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        } else {
            // an index for the cell could not be found
            print("ReminderList: ERROR - checked off cell is not in the table")
        }
    }
    
    

}
