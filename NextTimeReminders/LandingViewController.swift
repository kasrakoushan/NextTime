//
//  LandingViewController.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-20.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import UIKit
import FBSDKLoginKit

// the first view controller that the user will see, with a Facebook login button
class LandingViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // set up Facebook login button, approximate centre of screen
        
        // find screen size
        let screenFrame = UIScreen.mainScreen().bounds
        let frame = CGRectMake(screenFrame.midX - 50, screenFrame.midY - 20, 100, 40)
        // generate FB button with frame
        let loginButton = FBSDKLoginButton(frame: frame)
        // set requested FB data
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self
        // add the button to the view
        self.view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // *FBSDKLoginButtonDelegate* function called when login flow is complete
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        // check for errors
        if error == nil {
            print("Landing: no Facebook login errors, will obtain token now")
            
            // obtain the FB token from the result, if one exists
            if let userID = result?.token?.userID {
                print("Landing: obtained Facebook token with user ID \(userID)")
                
                // navigate to the list of reminders
                (UIApplication.sharedApplication().delegate as! AppDelegate).navigateToLoggedInViewController()
                
            }
        } else {
            // display an error message in the debugger
            print("Landing: Facebook login had error \(error.localizedDescription)")
        }
    }
    
    // *FBSDKLoginButtonDelegate* function called when the button is used to log out
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        // this should never be called, because the user logs out from the list of reminders
        print("Landing: logged out of Facebook")
    }

}
