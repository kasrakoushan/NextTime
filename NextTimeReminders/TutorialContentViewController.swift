//
//  TutorialContentViewController.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-11-06.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import UIKit

class TutorialContentViewController: UIViewController {

    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var pageImage: UIImageView!
    
    var pageIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.pageIndex! < TutorialViewController.pagePrompts.count - 1 {
            self.getStartedButton.hidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if let ind = pageIndex {
            self.pageLabel.text = TutorialViewController.pagePrompts[ind]
            self.pageImage.image = UIImage(named: TutorialViewController.pageImages[ind])
        } else {
            print("page index is nil")
        }
    }

    @IBAction func getStartedTapped(sender: UIButton) {
        AppSettings.loggedIn = true
        (UIApplication.sharedApplication().delegate as! AppDelegate).setupAppLoggedInBackground(false)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
