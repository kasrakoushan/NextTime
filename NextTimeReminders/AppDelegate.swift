//
//  AppDelegate.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-20.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import UIKit
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var mainNavigationController: UINavigationController?
    var landingViewController: LandingViewController?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // load reminders
        ReminderController.sharedInstance.loadReminders()
        
        // set up location manager
        AppLocationManager.sharedInstance.locationManager.startUpdatingLocation()
        
        // register for and request push notifications
        self.registerForPushNotifications(application)
        
        // set up window
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // initialize App Delegate's view controllers
        self.landingViewController = LandingViewController(nibName: "LandingViewController", bundle: nil)
        let reminderViewController = ReminderViewController(nibName: "ReminderViewController", bundle: nil)
        self.mainNavigationController = UINavigationController(rootViewController: reminderViewController)
        
        
        // determine whether the user has finished the tutorial
        
        print("-----------------------Launched-----------------------")
        if NSUserDefaults.standardUserDefaults().boolForKey("tutorialFinished") {
            self.window?.rootViewController = self.mainNavigationController
        } else {
            self.window?.rootViewController = self.landingViewController
        }
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("-----------------------Saving reminders on background-----------------------")
        AppLocationManager.sharedInstance.locationManager.stopUpdatingLocation()
        ReminderController.sharedInstance.saveReminders()
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        AppLocationManager.sharedInstance.locationManager.startUpdatingLocation()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("-----------------------Saving reminders on terminate-----------------------")
        ReminderController.sharedInstance.saveReminders()
    }
    
    // ************************** PUSH NOTIFICATION FUNCTIONS **************************
    
    // *helper* function for registering push notification settings
    func registerForPushNotifications(application: UIApplication) {
        // ask for Badge, Sound, and Alert notifications
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        // register these settings
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    // *UIApplicationDelegate* function called when the user accepts notification permissions
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types == UIUserNotificationType.None {
            print("user denied notifications")
        }
    }
    
    // ************************** APP LOGIN/LOGOUT NAVIGATION FUNCTIONS **************************
    // navigate to the mainNavigationController when logging in
    func navigateToLoggedInViewController() {
        self.window?.rootViewController = self.mainNavigationController
    }
    
    // navigate to the landingViewController when logging out
    func navigateToLoggedOutViewController() {
        self.window?.rootViewController = self.landingViewController
    }

}

