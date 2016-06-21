//
//  AppDelegate.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-20.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import UIKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainNavigationController: UINavigationController?
    var landingViewController: LandingViewController?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        if let notification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? [String: AnyObject] {
            let aps = notification["aps"] as! [String: AnyObject]
            print("notification received upon launch: \(aps)")
        }
        
        // launch the Facebook app
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // set up window
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // register for push notifications
        self.registerForPushNotifications(application)
        
        // initialize App Delegate's view controller properties
        self.landingViewController = LandingViewController(nibName: "LandingViewController", bundle: nil)
        let reminderViewController = ReminderViewController(nibName: "ReminderViewController", bundle: nil)
        self.mainNavigationController = UINavigationController(rootViewController: reminderViewController)
        
        // navigate to the correct view controller
        if let token = FBSDKAccessToken.currentAccessToken() {
            self.window?.rootViewController = self.mainNavigationController
            print("currently logged in with user ID:\(token.userID)")
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
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // *************** PUSH NOTIFICATION FUNCTIONS ***************
    
    // registers the push notification settings we want (helper function)
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    // handler for when the user accepts notification permissions (UIApplicationDelegate function)
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType.None {
            print("registering for remote notifications")
            application.registerForRemoteNotifications()
        }
    }
    
    // handler for when the app has registered for push notifications with success (UIApplicationDelegate function)
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("Registered: device token is \(deviceToken)")
    }
    
    
    // handler for when the app fails in registering for push notifications (UIApplicationDelegate function)
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register: \(error)")
    }
    
    // handler for receiving remote notification (UIApplicationDelegate function)
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("received remote notification: \(userInfo)")
    }
    
    // *************** APP NAVIGATION FUNCTIONS ***************
    func navigateToLoggedInViewController() {
        self.window?.rootViewController = self.mainNavigationController
    }
    
    func navigateToLoggedOutViewController() {
        self.window?.rootViewController = self.landingViewController
    }
    
    // *************** FB SDK LOGIN BUTTON DELEGATE ***************
    
    // UIApplicationDelegate function that responds to calls to open a certain URL
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }


}

