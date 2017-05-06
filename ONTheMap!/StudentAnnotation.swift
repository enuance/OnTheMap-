//
//  StudentAnnotation.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/24/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//
/*
 This file allows the map view to differentiate the user's pins from other's students in the data base.
 */

import Foundation
import MapKit

class StudentAnnotation: NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    //Differentiating property, the app user will always be assigned a unique identifier.
    var uniqueIdentifier: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, uniqueIdentifier: String?){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.uniqueIdentifier = uniqueIdentifier
    }
}
