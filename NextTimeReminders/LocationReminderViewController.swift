//
//  LocationReminderViewController.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-20.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import UIKit
import MapKit

class LocationReminderViewController: UIViewController {

    @IBOutlet var reminderDescriptionTextField: UITextField!
    var locationsToSave = [CLLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up navigation bar
        self.title = "Location Reminder"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(LocationReminderViewController.backButtonTapped))
        
        // set up tap gesture recognizer (for dismissing keyboard)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LocationReminderViewController.hideKeyboard))
        self.view.addGestureRecognizer(gestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func backButtonTapped() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func addButtonTapped(sender: UIButton) {
        self.view.endEditing(true)
        if self.locationsToSave.count != 0 {
            print("adding new reminder to the shared instance with written text")
            ReminderController.sharedInstance.addLocationReminder(reminderDescriptionTextField.text!, locations: self.locationsToSave)
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        } else {
            // present an alert saying "No matching locations nearby"
            print("no locations provided")
        }
    }
    
    @IBAction func searchForLocationsTapped(sender: UIButton) {
        self.locationsToSave = []
        let mapPopUpViewController = MapPopUpViewController(nibName: "MapPopUpViewController", bundle: nil)
        mapPopUpViewController.parentLocationReminderViewController = self
        self.presentViewController(mapPopUpViewController, animated: true, completion: nil)
    }
    
    func hideKeyboard() {
        self.reminderDescriptionTextField.resignFirstResponder()
    }
    

}
