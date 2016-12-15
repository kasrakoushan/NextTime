//
//  ReminderViewController.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-20.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import UIKit
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
        self.navigationItem.rightBarButtonItem = Helper.generateBarButtonWithImage(imageName: "add_new",
                                                                                   action: #selector(ReminderViewController.newReminderButtonTapped),
                                                                                   target: self)
        self.navigationItem.leftBarButtonItem = Helper.generateBarButtonWithImage(imageName: "edit_button",
                                                                                   action: #selector(ReminderViewController.settingsButtonTapped),
                                                                                   target: self)
        // set up the table's delegate and data source
        self.reminderTableView.delegate = self
        self.reminderTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // reload the table
        self.reminderTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.denied {
            let msg = "NextTime can't send you reminders without your location. Go to Settings and enable location services for this app."
            let alert = UIAlertController(title: "Location Unauthorized", message:msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alert) in self.checkNotificationStatus()}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func checkNotificationStatus() {
        let notifStatus = UIApplication.shared.currentUserNotificationSettings
        let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        if notifStatus != notificationSettings {
            let msg = "NextTime can't send you reminders. Go to Settings and enable push notifications for this app."
            let alert = UIAlertController(title: "Notifications Unauthorized", message:msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // add a new reminder
    func newReminderButtonTapped() {
        // location reminder
        let locationReminderViewController = LocationReminderViewController(nibName: "LocationReminderViewController", bundle: nil)
        self.navigationController?.pushViewController(locationReminderViewController, animated: true)
    }
    
    func settingsButtonTapped() {
        let storyboard = UIStoryboard.init(name: "Settings", bundle: nil)
        if let settingsViewController = storyboard.instantiateInitialViewController() {
            self.present(settingsViewController, animated: true, completion: nil)
        }
    }
    
    // ************************** TABLEVIEW FUNCTIONS **************************
    
    // *UITableViewDataSource* function: return number of reminders in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TO-DO: eventually divide into separate friend and location sections?
        return ReminderController.sharedInstance.reminders.count
    }
    
    // *UITableViewDataSource* function: return the cell at the given row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        
        // dequeue from existing cells if possible
        var cell: SWTableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SWTableViewCell
        if cell == nil {
            // if no cell was provided, initialize one
            cell = SWTableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
            cell.rightUtilityButtons = [] // no right utility buttons for now
            cell.leftUtilityButtons = self.getLeftUtilityButtons()
            cell.delegate = self
        }
        
        // set font for the textLabel and detailTextLabel
        cell.textLabel?.font = UIFont(name: "Kohinoor Bangla", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Kohinoor Bangla", size: 16)
        // set the textLabel to the reminder's body
        cell.textLabel?.text = ReminderController.sharedInstance.reminders[(indexPath as NSIndexPath).row].reminderDescription
        
        // set the detailTextLabel to the reminder status (either "Saved" or "Nearby")
        if ReminderController.sharedInstance.reminders[(indexPath as NSIndexPath).row].state == ReminderState.Active {
            cell.detailTextLabel?.text = "Nearby"
            cell.detailTextLabel?.textColor = UIColor.red
        } else {
            cell.detailTextLabel?.text = "Saved"
            cell.detailTextLabel?.textColor = UIColor.lightGray
        }
        
        return cell
    }
    
    
    // *UITableViewDelegate* function called when selecting a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // check if the reminder has annotations and a region (i.e. if it is a location reminder)
        if let annotations = ReminderController.sharedInstance.reminders[(indexPath as NSIndexPath).row].annotations,
            let region = ReminderController.sharedInstance.reminders[(indexPath as NSIndexPath).row].region {
            // reminder type is location
            
            // generate map that covers the whole screen
            let viewController = UIViewControllerWithCustomBackButton()
            let map = MKMapView(frame: viewController.view.bounds)
            viewController.view.addSubview(map)
            
            // add the reminder's annotations to the map, set the map's type, show current location
            map.addAnnotations(annotations)
            map.mapType = .hybridFlyover
            map.showsUserLocation = true
            
            // check if current location is accessible
            if let currentCoord = AppLocationManager.sharedInstance.locationManager.location?.coordinate {
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // somewhat larger than usual
        return 60
    }
    
    // ---------------------- SW Cell Functions ----------------------
    // SWTableViewCell is a custom cell that allows for swiping in both directions with several editing options
    
    // return the utility buttons on the left (only "complete" button for now)
    func getLeftUtilityButtons() -> [AnyObject] {
        let leftUtilityButtons = NSMutableArray()
        leftUtilityButtons.sw_addUtilityButton(with: UIColor.white, icon: UIImage(named: "complete_button"))
        return leftUtilityButtons as [AnyObject]
    }
    
    // *SWTableViewCellDelegate* function called when a utility button is tapped
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerLeftUtilityButtonWith index: Int) {
        // complete button has been tapped - remove selected reminder
        
        // get the index of the selected cell
        if let indexPath = self.reminderTableView.indexPath(for: cell) {
            // remove the reminder from the model
            ReminderController.sharedInstance.reminders.remove(at: (indexPath as NSIndexPath).row)
            // delete the reminder from the table
            self.reminderTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        } else {
            // an index for the cell could not be found
            print("ReminderList: ERROR - checked off cell is not in the table")
        }
    }
    
    

}
