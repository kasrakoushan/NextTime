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
    var annotations: [MKAnnotation]?
    var region: MKCoordinateRegion?
    
    // initializer
    init(description: String, type: ReminderType, annotationList: [MKAnnotation]? = nil, region: MKCoordinateRegion? = nil, friend: Friend? = nil) {
        self.reminderDescription = description
        self.state = .Saved
        self.type = type
        if type == .Location {
            // this should always execute if the reminder is of type location
            self.annotations = annotationList!
            self.region = region!
        }
    }
    
    // NSCoding functions
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.reminderDescription, forKey: "reminderDescription")
        aCoder.encodeObject(self.state.rawValue, forKey: "state")
        aCoder.encodeObject(self.type.rawValue, forKey: "type")
        if self.type == .Location {
            aCoder.encodeObject(self.annotations!.map({$0.produceWrapper()}), forKey: "annotations")
            aCoder.encodeDouble(self.region!.center.latitude, forKey: "latitude")
            aCoder.encodeDouble(self.region!.center.longitude, forKey: "longitude")
            aCoder.encodeDouble(self.region!.span.latitudeDelta, forKey: "latitudeDelta")
            aCoder.encodeDouble(self.region!.span.longitudeDelta, forKey: "longitudeDelta")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.reminderDescription = aDecoder.decodeObjectForKey("reminderDescription") as! String
        self.state = ReminderState(rawValue: aDecoder.decodeObjectForKey("state") as! String)!
        self.type = ReminderType(rawValue: aDecoder.decodeObjectForKey("type") as! String)!
        if self.type == .Location {
            self.annotations = (aDecoder.decodeObjectForKey("annotations") as! [AnnotationWrapper]).map({$0.annotation})
            self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: aDecoder.decodeDoubleForKey("latitude"),
                                                                            longitude: aDecoder.decodeDoubleForKey("longitude")),
                                             span: MKCoordinateSpan(latitudeDelta: aDecoder.decodeDoubleForKey("latitudeDelta"),
                                                                    longitudeDelta: aDecoder.decodeDoubleForKey("longitudeDelta")))
        }
    }
}