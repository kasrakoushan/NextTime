//
//  LocationExtensions.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-06-23.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import Foundation
import MapKit

// a bunch of helpful functions for converting between different map types

extension MKLocalSearchResponse {
    
    // create a map region with a bit of padding that covers the search results
    // default padding factor is 1.15
    func createRegionWithPadding(padding: Double = 1.15) -> MKCoordinateRegion {
        let paddedLatitudeDelta = self.boundingRegion.span.latitudeDelta * padding
        let paddedLongitudeDelta = self.boundingRegion.span.longitudeDelta * padding
        return MKCoordinateRegion(center: self.boundingRegion.center,
                                  span: MKCoordinateSpan(latitudeDelta: paddedLatitudeDelta, longitudeDelta: paddedLongitudeDelta))
    }
    
}

extension MKMapItem {

    // convert map items (search results) to point annotations for the map
    func convertToPointAnnotation() -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.placemark.coordinate
        annotation.title = self.name
        return annotation
    }
}

extension MKAnnotation {
    
    // convert point annotations to locations (for reminder checking)
    func convertToCLLocation() -> CLLocation {
        return CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
    }
    
    func produceWrapper() -> AnnotationWrapper {
        return AnnotationWrapper(annotation: self)
    }
    
}

// a wrapper for the MKPointAnnotation class, that allows for NSCoding
class AnnotationWrapper: NSObject, NSCoding {
    var annotation: MKAnnotation
    
    init(annotation: MKAnnotation) {
        self.annotation = annotation
    }
    
    required init?(coder aDecoder: NSCoder) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: aDecoder.decodeDoubleForKey("latitude"),
                                                       longitude: aDecoder.decodeDoubleForKey("longitude"))
        annotation.title = aDecoder.decodeObjectForKey("title") as? String
        self.annotation = annotation
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(self.annotation.coordinate.latitude, forKey: "latitude")
        aCoder.encodeDouble(self.annotation.coordinate.longitude, forKey: "longitude")
        aCoder.encodeObject(self.annotation.title!, forKey: "title")
    }
    
}