//
//  Student.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 3/17/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import Foundation

class Student{
    //objectID: an auto-generated id/key generated by Parse which uniquely identifies a StudentLocation
    private(set) var objectId: String!
    //uniqueKey: an optional key (ACCT/User ID) used to uniquely identify a StudentLocation
    private(set) var uniqueKey: String?
    //firstName: the first name of the student which matches their Udacity profile first name
    private(set) var firstName: String!
    //lastName: the last name of the student which matches their Udacity profile last name
    private(set) var lastName: String!
    //mapString: the location string used for geocoding the student location
    private(set) var mapString: String!
    //mediaUrl: the URL provided by the student
    private(set) var mediaURL: String!
    //latitude: the latitude of the student location (ranges from -90 to 90)
    private(set) var latitude: Float!
    //longitude: the longitude of the student location (ranges from -180 to 180)
    private(set) var longitude: Float!
    
    //property that checks if the Student is valid or usable
    var isValid: Bool{
        if objectId != nil && firstName != nil && lastName != nil &&
            mapString != nil && mediaURL != nil && latitude != nil && longitude != nil{
            if uniqueKey == nil{print("The optional property \"uniqueKey\" has not been set")}
            return true}
        else{return false}
    }
    
    private enum propertyName: String{
        case objectId = "objectId"
        case uniqueKey = "uniqueKey"
        case firstName = "firstName"
        case lastName = "lastName"
        case mapString = "mapString"
        case  mediaURL = "mediaURL"
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    
    
    func setPropertyBy(_ key: String, with value: Any){
        guard (value as? String != nil) || (value as? Float != nil) || (value as? Int != nil) || (value as? Double != nil) else {
            print("Student property setter could not use invalid type of \(value)")
            return
        }
        guard propertyName(rawValue: key) != nil else{
            print("The \(key) key is not a valid Student property")
            return
        }
        switch key {
        case propertyName.objectId.rawValue:
            objectId = value as? String
        case propertyName.uniqueKey.rawValue:
            uniqueKey = value as? String
        case propertyName.firstName.rawValue:
            firstName = value as? String
        case propertyName.lastName.rawValue:
            lastName = value as? String
        case propertyName.mapString.rawValue:
            mapString = value as? String
        case propertyName.mediaURL.rawValue:
            mediaURL = value as? String
        case propertyName.latitude.rawValue:
            let floatValue: Float
            switch value{
            case let someNum as Int:
                floatValue = Float(someNum)
            case let someNum as Double:
                floatValue = Float(someNum)
            case let someNum as String:
                guard let number = Float(someNum)
                    else{print("\(value) is not convertable to the proper Latitude Type");return}
                floatValue = number
            case let someNum as Float:
                floatValue = someNum
            default:
                print("\(value) is not convertable to the proper Latitude Type")
                return
            }
            guard (floatValue >= -90 && floatValue <= 90)
                else{print("Latitude Must be within range -90 to 90");return}
            latitude = floatValue
        case propertyName.longitude.rawValue:
            let floatValue: Float
            switch value{
            case let someNum as Int:
                floatValue = Float(someNum)
            case let someNum as Double:
                floatValue = Float(someNum)
            case let someNum as String:
                guard let number = Float(someNum)
                    else{print("\(value) is not convertable to the proper Longitude Type");return}
                floatValue = number
            case let someNum as Float:
                floatValue = someNum
            default:
                print("\(value) is not convertable to the proper Longitude Type")
                return
            }
            guard (floatValue >= -180 && floatValue <= 180) else{print("Longitude Must be within range -180 to 180");return}
            longitude = floatValue
        default:
            break
        }
    }
    
}

