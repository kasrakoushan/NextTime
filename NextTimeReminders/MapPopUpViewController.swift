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
        if let coordinate = AppLocationManager.sharedInstance.locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.mapView.setRegion(region, animated: true)
            self.mapView.showsUserLocation = true
            self.mapView.mapType = .hybridFlyover
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // set up map search bar
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        (self.searchController.searchBar.value(forKey: "searchField") as? UITextField)?.font = UIFont(name: "Kohinoor Bangla", size: 16)
        self.present(self.searchController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // resign first-responder status of search bar
        searchBar.resignFirstResponder()
        // dismiss the search bar
        self.dismiss(animated: true, completion: nil)
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
        localSearch.start() {(searchResponse, error) in
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
    
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if let parent = self.parentLocationReminderViewController,
            let region = self.regionToSave {
            // if parent is a LocationReminderViewController, pass along the found locations
            parent.annotationsToSave = self.annotationsToAdd
            parent.regionToSave = region
            parent.locationMessage = self.locationMessage
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func searchAgainButtonTapped(_ sender: UIButton) {
        self.present(self.searchController, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func recentreButtonTapped(_ sender: UIButton) {
        if let location = AppLocationManager.sharedInstance.locationManager.location , location.timestamp.timeIntervalSinceNow > -30 {
            // #CanadianSpelling
            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015))
            self.mapView.setRegion(region, animated: true)
            return
        } else {
            // present error
            let msg = "Current location not found. Ensure that this app has location permissions in Settings."
            let alert = UIAlertController(title: "Location Not Found", message:msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
