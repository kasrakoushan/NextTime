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

    @IBOutlet var locationDescriptionLabel: UILabel!
    // the text field for the reminder description
    @IBOutlet var reminderDescriptionTextField: UITextField!
    var annotationsToSave = [MKAnnotation]()
    var regionToSave = MKCoordinateRegion()
    var locationMessage = "Tap to find locations"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up navigation bar
        self.title = "Location Reminder"
        self.navigationItem.leftBarButtonItem = Helper.generateBarButtonWithImage(imageName: "back", action: #selector(LocationReminderViewController.backButtonTapped), target: self)
        
        // set up tap gesture recognizer (for dismissing keyboard)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LocationReminderViewController.hideKeyboard))
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // update the instructional message above the search for location button
        self.locationDescriptionLabel.text = self.locationMessage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.annotationsToSave.count != 0 {
            ReminderController.sharedInstance.addLocationReminder(reminderDescriptionTextField.text!,
                                                                  annotations: self.annotationsToSave, region: self.regionToSave)
            self.navigationController?.popViewController(animated: true)
        } else {
            self.locationDescriptionLabel.text = "No locations found"
        }
    }
    
    @IBAction func searchForLocationsTapped(_ sender: UIButton) {
        self.annotationsToSave = []
        let mapPopUpViewController = MapPopUpViewController(nibName: "MapPopUpViewController", bundle: nil)
        mapPopUpViewController.parentLocationReminderViewController = self
        self.present(mapPopUpViewController, animated: true, completion: nil)
    }
    
    func hideKeyboard() {
        self.reminderDescriptionTextField.resignFirstResponder()
    }
    

}
