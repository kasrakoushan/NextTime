//
//  ReminderController.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-22.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import Foundation
import MapKit

class ReminderController {
    // singleton design
    class var sharedInstance: ReminderController {
        struct Static {
            static var instance:ReminderController?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token)    {
            Static.instance = ReminderController()
        }
        return Static.instance!
    }
    
    // the threshold distance at which locations reminders will be sent
    static let NEARBY_THRESHOLD = 100.0
    
    var reminders = [Reminder]()
    
    func addLocationReminder(description: String, annotations: [MKAnnotation], region: MKCoordinateRegion) {
        let reminder = Reminder(description: description, type: .Location, annotationList: annotations, region: region)
        self.reminders.append(reminder)
    }
    
    func loadReminders() {
        let file = PersistenceManager.documentsDirectory().stringByAppendingString("/reminders.archive")
        if let reminders = NSKeyedUnarchiver.unarchiveObjectWithFile(file) as? [Reminder] {
            self.reminders = reminders
        }
        
    }
    
    func saveReminders() {
        let file = PersistenceManager.documentsDirectory().stringByAppendingString("/reminders.archive")
        NSKeyedArchiver.archiveRootObject(self.reminders, toFile: file)
    }
    
    func checkReminders(withRecentLocation lastLocation: CLLocation) {
        print("REMINDER STATES...")
        for rem in self.reminders {
            print(rem.state.rawValue)
        }
        
        // declare notification object to be shared
        var notification: UILocalNotification
        
        // if no one is logged in, don't send notifications
        if !NSUserDefaults.standardUserDefaults().boolForKey("tutorialFinished") {
            print("tutorial not yet finished")
            return
        }
        
        // save all current states
        // reload table if any state changed
        // reload the table data
        let currentStates = self.reminders.map({$0.state})
        
        // send appropriate notifications
        var anyLocation: Bool // whether any of the reminder's locations is nearby
        for reminder in self.reminders {
            anyLocation = false
            specificReminderLoop: for annotation in reminder.annotations! {
                // check distance from current location
                if lastLocation.distanceFromLocation(annotation.convertToCLLocation()) < ReminderController.NEARBY_THRESHOLD {
                    anyLocation = true
                    // generate notification
                    notification = UILocalNotification()
                    if let first = annotation.title, second = first {
                        notification.alertTitle = "Reminder: \(second)"
                    } else {
                        notification.alertTitle = "Reminder"
                    }
                    notification.alertBody = "\(reminder.reminderDescription)"
                    notification.soundName = "default"
                    
                    // only send a notification if the reminder is not already in notified state
                    if (reminder.state == .Saved) {
                        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
                    }
                    
                    // update the reminder state
                    reminder.state = .Active
                    
                    // don't check other locations within the same reminder
                    break specificReminderLoop
                }
            }
            if !anyLocation {
                reminder.state = .Saved
            }
            
        }
        
        // update app icon badge number
        UIApplication.sharedApplication().applicationIconBadgeNumber = self.reminders.filter({$0.state == .Active}).count
        
        // reload the table if any states changed
        if self.reminders.map({$0.state}) != currentStates {
            ((UIApplication.sharedApplication().delegate as? AppDelegate)?.mainNavigationController?.viewControllers.first as? ReminderViewController)?.reminderTableView.reloadData()
        }
        
    }
    
}