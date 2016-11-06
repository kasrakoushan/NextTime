//
//  LandingViewController.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-20.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import UIKit

// the first view controller that the user will see, with a Facebook login button
class LandingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tutorialFinished(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "tutorialFinished")
        (UIApplication.sharedApplication().delegate as! AppDelegate).navigateToLoggedInViewController()
    }
    

}
