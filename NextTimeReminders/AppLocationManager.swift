//
//  AppLocationManager.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-11-06.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import Foundation
import MapKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class AppLocationManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance: AppLocationManager = {
        let instance = AppLocationManager()
        
        // setup code
        
        return instance
    }()
    
    var locationManager: CLLocationManager
    
    override init() {
        // initialize location manager
        self.locationManager = CLLocationManager()
        // call super
        super.init()
        // configure the location manager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = AppSettings.locationAccuracy
        if !AppSettings.ignoreBackground {
            self.locationManager.startMonitoringSignificantLocationChanges()
        }
        self.checkStatus()
    }
    
    func checkStatus() {
        // examine status
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            // request authorization from user
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    // *CLLocationManagerDelegate* function called when location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // check reminders with this new location
        if locations.last?.timestamp.timeIntervalSinceNow > -10 {
            // only check recent location updates
            ReminderController.sharedInstance.checkReminders(withRecentLocation: locations.last!)
            // save reminder status
            ReminderController.sharedInstance.saveReminders()
        }
    }
    
    // *CLLocationManagerDelegate* function called when location fails to update
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("-----------------------Location update failed-----------------------")
        print(error.localizedDescription)
        self.checkStatus()
    }
}
