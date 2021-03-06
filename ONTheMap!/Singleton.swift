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
    var user = Student()
    var locations = [Student]()
    var pins = [StudentAnnotation]()
    var userName: String!
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
    
    //Emptys out the User's posting info
    class func clearUserPostingInfo(){
        let clearedInfo: [String : Any] = [
            StudentCnst.objectId : "",
            StudentCnst.mediaURL : "",
            StudentCnst.mapString : "",
            StudentCnst.latitude : 0,
            StudentCnst.longitude : 0]
        for (key, value) in clearedInfo{shared.user.setPropertyBy(key, with: value)}
    }
    
    //Shared URL Session for the App.
    let session = URLSession.shared
    //Singleton instance for the OnTheMap Class
    static let shared = OnTheMap()
    //Prevents outside initialization
    private init(){}
}
