//
//  AppLocationManager.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-11-06.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import Foundation
import MapKit

class AppLocationManager: NSObject, CLLocationManagerDelegate {
    // singleton design
    class var sharedInstance: AppLocationManager {
        struct Static {
            static var instance:AppLocationManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token)    {
            Static.instance = AppLocationManager()
        }
        return Static.instance!
    }
    
    var locationManager: CLLocationManager
    
    override init() {
        // initialize location manager
        self.locationManager = CLLocationManager()
        // call super
        super.init()
        // configure the location manager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.checkStatus()
    }
    
    func checkStatus() {
        // examine status
        let status = CLLocationManager.authorizationStatus()
        if status == .Denied || status == .Restricted {
            // print an error and return
        } else if status == .NotDetermined {
            // request authorization from user
            self.locationManager.requestAlwaysAuthorization()
        }
        else {
            print("location already authorized: status is \(status.rawValue)")
            // if app is terminated, will launch app upon significant location changes
            self.locationManager.startMonitoringSignificantLocationChanges()
            // update locations for when the app is running
            // self.locationManager.startUpdatingLocation()
        }
    }
    
    
    // *CLLocationManagerDelegate* function called when the user's authorization status is updated
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        self.checkStatus()
    }
    
    // *CLLocationManagerDelegate* function called when location is updated
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // check reminders with this new location
        ReminderController.sharedInstance.checkReminders(withRecentLocation: locations.last!)
        // save reminder status
        ReminderController.sharedInstance.saveReminders()
    }
    
    // *CLLocationManagerDelegate* function called when location fails to updates
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("-----------------------Location update failed-----------------------")
        print(error.localizedDescription)
    }
}