//
//  Reminder.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-22.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import Foundation
import MapKit

enum ReminderState: String {
    case Saved = "SAVED" // the reminder has been created, waiting for notifications
    case Active = "ACTIVE" // the reminder is in notification mode
    case Complete = "COMPLETE" // the reminder has been completed
}

enum ReminderType: String {
    case Location = "LOCATION"
    case Friend = "FRIEND"
}

class Friend {
    var name: String = "kasra"
}

class Reminder: NSObject, NSCoding {
    var reminderDescription:String
    var state: ReminderState
    var type: ReminderType
    var locations: [CLLocation]
    
    // initializer
    init(description: String, type: ReminderType, searchQuery: String = "", friend: Friend? = nil) {
        self.reminderDescription = description
        self.state = .Saved
        self.type = type
        if self.type == .Location {
            self.locations = Reminder.generateLocationListForQuery(searchQuery)
        } else {
            self.locations = Reminder.generateLocationFromFriend(friend)
        }
    }
    
    // NSCoding functions
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.reminderDescription, forKey: "description")
        aCoder.encodeObject(self.state.rawValue, forKey: "state")
        aCoder.encodeObject(self.type.rawValue, forKey: "type")
        aCoder.encodeObject(self.locations, forKey: "locations")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.reminderDescription = aDecoder.decodeObjectForKey("description") as! String
        self.state = ReminderState(rawValue: aDecoder.decodeObjectForKey("state") as! String)!
        self.type = ReminderType(rawValue: aDecoder.decodeObjectForKey("type") as! String)!
        self.locations = aDecoder.decodeObjectForKey("locations") as! [CLLocation]
    }
    
    // class functions for generating location lists
    class func generateLocationListForQuery(query: String?) -> [CLLocation] {
        if let _ = query {
            // do a search of apple maps for a list of locations
            return [CLLocation(latitude: -33.907772, longitude: 18.4069913),
                    CLLocation(latitude: -33.9072776, longitude: 18.4187435)]
        } else {
            return []
        }
    }
    
    class func generateLocationFromFriend(friend: Friend?) -> [CLLocation] {
        // make some calls to the server to obtain friend's location
        return []
    }
}