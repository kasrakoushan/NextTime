//
//  AppDelegate.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-20.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var mainNavigationController: UINavigationController?
    var landingViewController: LandingViewController?
    var locationManager: CLLocationManager?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // load reminders
        ReminderController.sharedInstance.loadReminders()
        
        // set up location manager, request authorization
        self.setUpLocationManager()
        
        // register for and request push notifications
        self.registerForPushNotifications(application)
        
        // launch the Facebook app
        FBSDKApplicationDelegate.sharedInstance().application(application,
                                                              didFinishLaunchingWithOptions: launchOptions)
        
        // set up window
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // initialize App Delegate's view controllers
        self.landingViewController = LandingViewController(nibName: "LandingViewController", bundle: nil)
        let reminderViewController = ReminderViewController(nibName: "ReminderViewController", bundle: nil)
        self.mainNavigationController = UINavigationController(rootViewController: reminderViewController)
        
        print("-----------------------Launched-----------------------")
        // navigate to the correct view controller, depending on whether user is logged into FB
        if let token = FBSDKAccessToken.currentAccessToken() {
            print("Launch: currently logged in with FB user ID:\(token.userID)")
            self.window?.rootViewController = self.mainNavigationController
        } else {
            print("Launch: no FB user logged in")
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
        ReminderController.sharedInstance.saveReminders()
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
        if notificationSettings.types != UIUserNotificationType.None {
            // if the user registered for any notification settings, register for remote notifications
            application.registerForRemoteNotifications()
        }
    }
    
    
    // *UIApplicationDelegate* function called when the app fails in registering for push notifications
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("-----------------------Failed to register for remote notifications-----------------------")
        print("Error is \(error.localizedDescription)")
    }
    
    // *UIApplicationDelegate* called when a remote notification is received
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("-----------------------Remote notification-----------------------")
        print("Notification: \(userInfo)")
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
    
    // ************************** FACEBOOK SDK **************************
    
    // *UIApplicationDelegate* function that responds to calls to open a given URL
    // will use the FB app to open the URL
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    // ************************** LOCATION MANAGER DELEGATE **************************
    
    // *helper* function for setting up the location manager
    func setUpLocationManager() {
        // initialize location manager, set delegate, accuracy
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        // request authorization from user
        self.locationManager?.requestAlwaysAuthorization()
    }
    
    // *CLLocationManagerDelegate* function called when the user's authorization status is updated
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways {
            // track significant changes, regardless of app state
            // if app is terminated, will launch app upon significant location changes
            self.locationManager?.startMonitoringSignificantLocationChanges()
            // update locations for when the app is running
            self.locationManager?.startUpdatingLocation()
        } else {
            print("-----------------------Location authorization denied-----------------------")
        }
    }
    
    // *CLLocationManagerDelegate* function called when location is updated
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // check reminders with this new location
        ReminderController.sharedInstance.checkReminders(withRecentLocation: locations.last!)
        // TO-DO: send new location to server
    }
    
    // *CLLocationManagerDelegate* function called when location fails to updates
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("-----------------------Location update failed-----------------------")
    }

}

