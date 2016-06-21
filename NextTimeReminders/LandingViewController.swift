//
//  LandingViewController.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-20.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class LandingViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // set up Facebook login button
        let screenFrame = UIScreen.mainScreen().bounds
        let frame = CGRectMake(screenFrame.midX - 50, screenFrame.midY - 20, 100, 40)
        let loginButton = FBSDKLoginButton(frame: frame)
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self
        self.view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // FBSDKLoginButtonDelegate function
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error == nil {
            print("logged in")
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(result.token.tokenString)
            FIRAuth.auth()?.signInWithCredential(credential) {(user, error) in
                if error == nil {
                    print("signed in successfully: user \(user!.email)")
                } else {
                    print("error signing in: error \(error!.localizedDescription)")
                }
                // will have to do something with the database
            }
            let app = UIApplication.sharedApplication().delegate as! AppDelegate
            app.navigateToLoggedInViewController()
        } else {
            print("did not log in")
            print("error: \(error.localizedDescription)")
        }
    }
    
    // FBSDKLoginButtonDelegate function
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        // set logged out user in UserController
        print("logged out")
    }

}
