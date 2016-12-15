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
    static let sharedInstance: ReminderController = {
        let instance = ReminderController()
        
        // setup code
        
        return instance
    }()
    
    // the threshold distance at which locations reminders will be sent
    static let NEARBY_THRESHOLD = 100.0
    
    var reminders = [Reminder]()
    var reminderViewController: ReminderViewController? = nil
    
    func addLocationReminder(_ description: String, annotations: [MKAnnotation], region: MKCoordinateRegion) {
        let reminder = Reminder(description: description, type: .Location, annotationList: annotations, region: region)
        self.reminders.append(reminder)
    }
    
    func loadReminders() {
        let file = PersistenceManager.documentsDirectory().appending("/reminders.archive")
        if let reminders = NSKeyedUnarchiver.unarchiveObject(withFile: file) as? [Reminder] {
            self.reminders = reminders
        }
        
    }
    
    func saveReminders() {
        let file = PersistenceManager.documentsDirectory().appending("/reminders.archive")
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
        if !AppSettings.loggedIn {
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
                if lastLocation.distance(from: annotation.convertToCLLocation()) < ReminderController.NEARBY_THRESHOLD {
                    anyLocation = true
                    // generate notification
                    notification = UILocalNotification()
                    if let first = annotation.title, let second = first {
                        notification.alertTitle = "Reminder: \(second)"
                    } else {
                        notification.alertTitle = "Reminder"
                    }
                    notification.alertBody = "\(reminder.reminderDescription)"
                    notification.soundName = "default"
                    
                    // only send a notification if the reminder is not already in notified state
                    if (reminder.state == .Saved) {
                        UIApplication.shared.presentLocalNotificationNow(notification)
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
        UIApplication.shared.applicationIconBadgeNumber = self.reminders.filter({$0.state == .Active}).count
        
        // reload the table if any states changed
        if self.reminders.map({$0.state}) != currentStates {
            self.reminderViewController?.reminderTableView.reloadData()
        }
        
    }
    
}
