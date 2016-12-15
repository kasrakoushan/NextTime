//
//  AppDelegate.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-20.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import UIKit
import MapKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        // set up window
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if AppSettings.loggedIn {
            // load main screen
            if let _ = launchOptions?[UIApplicationLaunchOptionsKey.location] {
                // launched in background
                self.setupAppLoggedInBackground(true)
            }
            else {
                // launched in foreground
                self.setupAppLoggedInBackground(false)
            }
        } else {
            // load the tutorial screens
            let tutorial = UIStoryboard(name: "Tutorial", bundle: nil)
            self.window?.rootViewController = tutorial.instantiateInitialViewController()
        }
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if AppSettings.loggedIn {
            AppLocationManager.sharedInstance.locationManager.stopUpdatingLocation()
            ReminderController.sharedInstance.saveReminders()
        }
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if AppSettings.loggedIn {
            AppLocationManager.sharedInstance.locationManager.startUpdatingLocation()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        if AppSettings.loggedIn {
            ReminderController.sharedInstance.saveReminders()
        }
    }
    
    // ************************** PUSH NOTIFICATION FUNCTIONS **************************
    
    // *helper* function for registering push notification settings
    func managePushNotifications() {
        // check for iOS 10
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in print("requested authorization")})
        }
            
        else { //If user is not on iOS 10 use the old methods we've been using
            // ask for Badge, Sound, and Alert notifications
            let notificationSettings = UIUserNotificationSettings(
                types: [.badge, .sound, .alert], categories: nil)
            if UIApplication.shared.currentUserNotificationSettings != notificationSettings {
                // register these settings
                UIApplication.shared.registerUserNotificationSettings(notificationSettings)
            }
            
        }
    }
    
    @nonobjc @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        //Handle the notification
    }
    
    @nonobjc @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        //Handle the notification
    }
    
    // ************************** APP NAVIGATION FUNCTIONS **************************
    // navigate to the main part of the app
    func setupAppLoggedInBackground(_ launchedInBackground: Bool) {
        // load reminders
        ReminderController.sharedInstance.loadReminders()
        
        // set up location manager
        let lm = AppLocationManager.sharedInstance.locationManager
        if !launchedInBackground {
            lm.startUpdatingLocation()
        }
        
        // register for and request push notifications
        self.managePushNotifications()
        
        // set up the root window
        let reminderViewController = ReminderViewController(nibName: "ReminderViewController", bundle: nil)
        ReminderController.sharedInstance.reminderViewController = reminderViewController
        let navigationController = UINavigationController(rootViewController: reminderViewController)
        self.window?.rootViewController = navigationController
    }

}

