//
//  ReminderController.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-22.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import Foundation
import MapKit
import FBSDKLoginKit

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
    
    var reminders = [Reminder]()
    
    func addLocationReminder(description: String, locations: [CLLocation]) {
        let reminder = Reminder(description: description, type: .Location, locationList: locations)
        self.reminders.append(reminder)
    }
    
    func loadReminders() {
        let file = PersistenceManager.documentsDirectory().stringByAppendingString("/reminders.archive")
        if let reminders = NSKeyedUnarchiver.unarchiveObjectWithFile(file) as? [Reminder] {
            print("--------------------------LOADED REMINDERS-------------------------- \n \(reminders)")
            self.reminders = reminders
        }
        
    }
    
    func saveReminders() {
        let file = PersistenceManager.documentsDirectory().stringByAppendingString("/reminders.archive")
        print("--------------------------SAVED REMINDERS-------------------------- \n \(file)")
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
        if FBSDKAccessToken.currentAccessToken() == nil {
            print("no logged in user")
            return
        }
        
        // send appropriate notifications
        var anyLocation: Bool // whether any of the reminder's locations is nearby
        for reminder in self.reminders {
            anyLocation = false
            specificReminderLoop: for location in reminder.locations {
                // check distance from current location
                if lastLocation.distanceFromLocation(location) < 100 {
                    anyLocation = true
                    // generate notification
                    notification = UILocalNotification()
                    notification.alertBody = "Reminder: \(reminder.reminderDescription)"
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
        
        // update badge
        notification = UILocalNotification()
        var activated = 0
        for reminder in self.reminders {
            if reminder.state == .Active {
                print("increment activated, reminder: \(reminder.reminderDescription)")
                activated += 1
            }
        }
//        notification.applicationIconBadgeNumber = activated
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
}