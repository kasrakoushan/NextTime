//
//  AppSettings.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-11-10.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import Foundation
import MapKit

class AppSettings {
    
    static var loggedIn: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey("tutorialFinished")
        }
        set (value) {
            NSUserDefaults.standardUserDefaults().setBool(value, forKey: "tutorialFinished")
        }
    }
    
    static var ignoreBackground: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey("ignoreBackground")
        }
        set (value) {
            if value {
                AppLocationManager.sharedInstance.locationManager.stopMonitoringSignificantLocationChanges()
            } else {
                AppLocationManager.sharedInstance.locationManager.startMonitoringSignificantLocationChanges()
            }
            NSUserDefaults.standardUserDefaults().setBool(value, forKey: "ignoreBackground")
        }
    }
    
    static var locationAccuracy: CLLocationAccuracy {
        get {
            let acc = NSUserDefaults.standardUserDefaults().doubleForKey("locationAccuracy")
            if acc != 0 {
                return acc
            } else {
                return kCLLocationAccuracyBest // corresponds to -1
            }
        }
        set (value) {
            NSUserDefaults.standardUserDefaults().setDouble(value, forKey: "locationAccuracy")
            AppLocationManager.sharedInstance.locationManager.desiredAccuracy = value
        }
    }
    
}