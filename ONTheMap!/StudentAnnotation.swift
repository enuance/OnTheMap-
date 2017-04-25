//
//  StudentAnnotation.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/24/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import Foundation
import MapKit

class StudentAnnotation: NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var uniqueIdentifier: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, uniqueIdentifier: String?){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.uniqueIdentifier = uniqueIdentifier
    }
}
