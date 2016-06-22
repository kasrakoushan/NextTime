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
    
    // location search variables
    var annotationsToAdd = [MKAnnotation]()
    var searchController:UISearchController!

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
        // create search
        let localSearch = MKLocalSearch(request: localSearchRequest)
        // start search
        localSearch.startWithCompletionHandler() {(searchResponse, error) in
            if searchResponse == nil {
                print("search response error")
                print("error: \(error?.localizedDescription)")
                return
            }
            
            // set the region of the map to cover the search results
            let paddedLatitudeDelta = searchResponse!.boundingRegion.span.latitudeDelta * 1.15
            let paddedLongitudeDelta = searchResponse!.boundingRegion.span.longitudeDelta * 1.15
            let paddedRegion = MKCoordinateRegion(center: searchResponse!.boundingRegion.center,
                span: MKCoordinateSpan(latitudeDelta: paddedLatitudeDelta, longitudeDelta: paddedLongitudeDelta))
            self.mapView.setRegion(paddedRegion, animated: true)
            
            // annotate all of the search results on the map
            // there's probably a syntactically cleaner way to do this
            var annotations = [MKAnnotation]()
            print("map items count: \(searchResponse!.mapItems.count)")
            for item in searchResponse!.mapItems {
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                annotations.append(annotation)
            }
            self.mapView.addAnnotations(annotations)
            self.annotationsToAdd = annotations
        }
    }
    
    
    @IBAction func doneButtonTapped(sender: UIButton) {
        if let parent = self.parentLocationReminderViewController {
            // if parent is a LocationReminderViewController, pass along the found locations
            for annotation in self.annotationsToAdd {
                let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                parent.locationsToSave.append(location)
            }
        } 
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func searchAgainButtonTapped(sender: UIButton) {
        self.presentViewController(self.searchController, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

}
