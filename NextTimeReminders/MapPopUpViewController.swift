//
//  MapPopUpViewController.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-22.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import UIKit
import MapKit

class MapPopUpViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var mapView: MKMapView!
    var locationMessage: String = ""
    
    // location search variables
    var annotationsToAdd = [MKAnnotation]()
    var searchController:UISearchController!
    var regionToSave: MKCoordinateRegion!

    // a reference for the parent view controller
    var parentLocationReminderViewController: LocationReminderViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up map
        if let coordinate = (UIApplication.sharedApplication().delegate as? AppDelegate)?.locationManager?.location?.coordinate {
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.mapView.setRegion(region, animated: true)
            self.mapView.showsUserLocation = true
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        
        // set up map search bar
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        self.presentViewController(self.searchController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // resign first-responder status of search bar
        searchBar.resignFirstResponder()
        // dismiss the search bar
        self.dismissViewControllerAnimated(true, completion: nil)
        // remove all current annotations
        for item in self.mapView.annotations {
            self.mapView.removeAnnotation(item)
        }
        
        // create search request
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        self.locationMessage = searchBar.text!
        localSearchRequest.region = self.mapView.region
        // create search
        let localSearch = MKLocalSearch(request: localSearchRequest)
        // execute search
        localSearch.startWithCompletionHandler() {(searchResponse, error) in
            if error != nil {
                print("search response error")
                print("error: \(error!.localizedDescription)")
                return
            }
            
            // set the region of the map to cover the search results
            if let response = searchResponse {
                self.mapView.setRegion(response.createRegionWithPadding(), animated: true)
                print("map items count: \(searchResponse!.mapItems.count)")
                // annotate all of the search results on the map
                self.mapView.addAnnotations(response.mapItems.map({$0.convertToPointAnnotation()}))
                self.annotationsToAdd = response.mapItems.map({$0.convertToPointAnnotation()})
                self.regionToSave = response.createRegionWithPadding()
            }
        }
    }
    
    
    @IBAction func doneButtonTapped(sender: UIButton) {
        if let parent = self.parentLocationReminderViewController,
            region = self.regionToSave {
            // if parent is a LocationReminderViewController, pass along the found locations
            parent.annotationsToSave = self.annotationsToAdd
            parent.regionToSave = region
            parent.locationMessage = self.locationMessage
        }
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func searchAgainButtonTapped(sender: UIButton) {
        self.presentViewController(self.searchController, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func recentreButtonTapped(sender: UIButton) {
        if let centre = (UIApplication.sharedApplication().delegate as? AppDelegate)?.locationManager?.location?.coordinate {
            // #CanadianSpelling
            let region = MKCoordinateRegion(center: centre, span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015))
            self.mapView.setRegion(region, animated: true)
        }
    }
}
