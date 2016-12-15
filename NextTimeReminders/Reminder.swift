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
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.reminderDescription, forKey: "reminderDescription")
        aCoder.encode(self.state.rawValue, forKey: "state")
        aCoder.encode(self.type.rawValue, forKey: "type")
        if self.type == .Location {
            aCoder.encode(self.annotations!.map({$0.produceWrapper()}), forKey: "annotations")
            aCoder.encode(self.region!.center.latitude, forKey: "latitude")
            aCoder.encode(self.region!.center.longitude, forKey: "longitude")
            aCoder.encode(self.region!.span.latitudeDelta, forKey: "latitudeDelta")
            aCoder.encode(self.region!.span.longitudeDelta, forKey: "longitudeDelta")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.reminderDescription = aDecoder.decodeObject(forKey: "reminderDescription") as! String
        self.state = ReminderState(rawValue: aDecoder.decodeObject(forKey: "state") as! String)!
        self.type = ReminderType(rawValue: aDecoder.decodeObject(forKey: "type") as! String)!
        if self.type == .Location {
            self.annotations = (aDecoder.decodeObject(forKey: "annotations") as! [AnnotationWrapper]).map({$0.annotation})
            self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: aDecoder.decodeDouble(forKey: "latitude"),
                                                                            longitude: aDecoder.decodeDouble(forKey: "longitude")),
                                             span: MKCoordinateSpan(latitudeDelta: aDecoder.decodeDouble(forKey: "latitudeDelta"),
                                                                    longitudeDelta: aDecoder.decodeDouble(forKey: "longitudeDelta")))
        }
    }
}
