//
//  Singleton.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 3/8/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import Foundation
import MapKit

class OnTheMap{
    let user = Student()
    var locations = [Student]()
    var pins = [StudentAnnotation]()
    
    //Erase userName as soon as it has been used!
    var userName: String!
    //Erase userPassword as soon as it has been used!
    var userPassword: String!
    //Checks if locations is full up to the max amount.
    var isFull: Bool{return (locations.count >= ParseCnst.maxLocations)}
    //Makes Map Pins for the available Student Locations.
    class func pinTheLocations(){
        for location in shared.locations{
            let latitude =  CLLocationDegrees(location.latitude)
            let longitude = CLLocationDegrees(location.longitude)
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            let name = "\(location.firstName!) \(location.lastName!)"
            let mediaURL = "\(location.mediaURL!)"
            let aPin = StudentAnnotation(coordinate: coordinate, title: name, subtitle: mediaURL, uniqueIdentifier: location.uniqueKey)
            shared.pins.append(aPin)
        }
    }
    
    //Emptys out the locations & Pins list.
    class func clearLocationsAndPins(){
        shared.locations = [Student]()
        shared.pins = [StudentAnnotation]()
    }
    //Shared URL Session for the App.
    let session = URLSession.shared
    //Singleton instance for the OnTheMap Class
    static let shared = OnTheMap()
    private init(){}
}
