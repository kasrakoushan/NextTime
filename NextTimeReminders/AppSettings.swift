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
            return UserDefaults.standard.bool(forKey: "tutorialFinished")
        }
        set (value) {
            UserDefaults.standard.set(value, forKey: "tutorialFinished")
        }
    }
    
    static var ignoreBackground: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "ignoreBackground")
        }
        set (value) {
            if value {
                AppLocationManager.sharedInstance.locationManager.stopMonitoringSignificantLocationChanges()
            } else {
                AppLocationManager.sharedInstance.locationManager.startMonitoringSignificantLocationChanges()
            }
            UserDefaults.standard.set(value, forKey: "ignoreBackground")
        }
    }
    
    static var locationAccuracy: CLLocationAccuracy {
        get {
            let acc = UserDefaults.standard.double(forKey: "locationAccuracy")
            if acc != 0 {
                return acc
            } else {
                return kCLLocationAccuracyBest // corresponds to -1
            }
        }
        set (value) {
            UserDefaults.standard.set(value, forKey: "locationAccuracy")
            AppLocationManager.sharedInstance.locationManager.desiredAccuracy = value
        }
    }
    
}
