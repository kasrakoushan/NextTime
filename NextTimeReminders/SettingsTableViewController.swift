//
//  SettingsTableViewController.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-11-10.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import UIKit
import MapKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var backgroundSwitch: UISwitch!
    var accuracyIndex = 0
    var accuracies = [kCLLocationAccuracyBest, kCLLocationAccuracyNearestTenMeters,
                      kCLLocationAccuracyHundredMeters, kCLLocationAccuracyKilometer,
                      kCLLocationAccuracyThreeKilometers]
    
    @IBOutlet var cellImages: [UIImageView]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.rightBarButtonItem = Helper.generateBarButtonWithImage(imageName: "complete_button",
                                                                                   action: #selector(SettingsTableViewController.doneButtonTapped),
                                                                                   target: self)
        self.backgroundSwitch.isOn = !AppSettings.ignoreBackground
        
        
        accuracyIndex = accuracies.index(of: AppSettings.locationAccuracy)!
        cellImages[accuracyIndex].image = UIImage(named: "complete_button")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doneButtonTapped() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backgroundModeSwitched(_ sender: UISwitch) {
        if sender.isOn {
            AppSettings.ignoreBackground = false
        } else {
            AppSettings.ignoreBackground = true
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 1 {
            self.tableView.deselectRow(at: indexPath, animated: true)
            if (indexPath as NSIndexPath).row != accuracyIndex {
                cellImages[accuracyIndex].image = nil
                accuracyIndex = (indexPath as NSIndexPath).row
                cellImages[accuracyIndex].image = UIImage(named: "complete_button")
                AppSettings.locationAccuracy = accuracies[accuracyIndex]
            }
        }
    }
    

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
