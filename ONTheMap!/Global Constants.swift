//
//  Global Constants.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 3/3/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//
/*
This file contains the constant values that will be used widely throughout the application and are placed here for easy 
access and referencing as well as to avoid Magic Numbers. All Structs and Objects will contain the suffix Cnst (Standing
for Constant).
*/

import Foundation
import CoreGraphics
import UIKit

//These Parse API Values are publically used by other Udacity Student and thus can be overwritten at any time.
struct ParseCnst {
    //The Parse API Base URL
    static let apiHostURL = "parse.udacity.com"
    static let apiPath = "/parse/classes"
    //The API Key and Value
    static let headerAPIKey = "X-Parse-REST-API-Key"
    static let headerAPIValue = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    //The Application ID Key and Value
    static let headerAppIDKey = "X-Parse-Application-Id"
    static let headerAppIDValue = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    //Parse API Methods: 
    //For Student Location, the HTTP request type would be either GET or POST.
    static let methdStudentLocation = "/StudentLocation"
    static let parameterSkip = "skip"
    static let parameterLimit = "limit"
    static let parameterOrder = "order"
    static let parameterWhere = "where"
    static let parameterOrderValue = "-updatedAt"
    static let updated = "updatedAt"
    //JSON Object Returned from Student Location Method
    static let returnedResults = "results"
    //Maximum amount of locations to fill the locations array in the OnTheMapSingleton
    static let maxLocations = 100
}

struct StudentCnst{
    static let objectId = "objectId"
    static let uniqueKey = "uniqueKey"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let mapString = "mapString"
    static let mediaURL = "mediaURL"
    static let latitude = "latitude"
    static let longitude = "longitude"
    
    static func check(property: String) -> Bool{
        switch property{
        case StudentCnst.objectId: return true
        case StudentCnst.uniqueKey: return true
        case StudentCnst.firstName: return true
        case StudentCnst.lastName: return true
        case StudentCnst.mapString: return true
        case StudentCnst.mediaURL: return true
        case StudentCnst.latitude: return true
        case StudentCnst.longitude: return true
        default: return false
        }
    }
}

struct UdacityCnst{
    //The Udacity API Base URL
    static let apiHostURL = "www.udacity.com"
    static let apiPath = "/api"
    //Udacity API Method:
    //To Authenticate set HTTP Request to POST, to logOut set to DELETE.
    static let methdSessionID = "/session"
    static let methdGetUserInfo = "/users/"//extend with user ID Here
    //Returned JSONObject Keys
    static let accntDictName = "account"
    static let accntRegisteredKey = "registered"
    static let accntIDKey = "key"
    static let sessionDictName = "session"
    static let sessionIDKey = "id"
    //Returned JSONObject Keys for Public Data
    static let user = "user"
    static let lastName = "last_name"
    static let firstName = "first_name"
    //Ending a Session
    static let cookieName = "XSRF-TOKEN"
    static let cookieHeaderField = "X-XSRF-TOKEN"
}

struct MethodType {
    static let post = "POST"
    static let get = "GET"
    static let delete = "DELETE"
    static let put = "PUT"
}

struct PostHeader {
    static let ContentTypeKey = "Content-Type"
    static let appAndCharSetValue = "application/json;charset=utf-8"
}

struct URLCnst {
    //parseURL produces a Websafe String to be used as a URL
    //The search query parameter is expects a single key value pair for searching for students by that criteria
    //The Object ID is for use with the PUT type request when updating a students location
    //Both parameters are optional and default to nil, so that they can be ommited if not needed
    static func fromParse(_ searchQuery: [String : Any]? = nil, _ objectID: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = ParseCnst.apiHostURL
        components.path = ParseCnst.apiPath + ParseCnst.methdStudentLocation + (objectID != nil ? "/\(objectID!)":"")
        if let searchQuery = searchQuery{
            components.queryItems = [URLQueryItem]()
            for (key, value) in searchQuery {
                let queryItem = URLQueryItem(name: "where", value: "{\"\(key)\":\"\(value)\"}")
                components.queryItems!.append(queryItem)
            }
        }
        return components.url!
    }
    
    static func fromParseWith(_ parameters: [String : Any]) -> URL{
        var components = URLComponents()
        components.scheme = "https"
        components.host = ParseCnst.apiHostURL
        components.path = ParseCnst.apiPath + ParseCnst.methdStudentLocation
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters{
            let queryItem = URLQueryItem(name: "\(key)", value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    
    //The Udacity URL either accepts a user ID string parameter or nothing to produce a URL
    static func fromUdacity(_ withUserID: String? = nil) -> URL{
        var components = URLComponents()
        components.scheme = "https"
        components.host = UdacityCnst.apiHostURL
        components.path = UdacityCnst.apiPath + ( withUserID != nil ? (UdacityCnst.methdGetUserInfo + withUserID!) : UdacityCnst.methdSessionID)
        return components.url!
    }
    
    // The Udacity URL for creating a student account.
    static let createAccntURL = "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated"
}


struct ConvertObject{
    //Use This Method when sending Data to a server
    static func toJSON(with object: AnyObject) -> (JSONObject: Data?, error: NetworkError?){
        var wouldBeJSON: Data? = nil
        do{ wouldBeJSON = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)}
        //Conversion failed, return nil with NetworkError.
        catch{return (wouldBeJSON, NetworkError.JSONToData)}
        //Conversion Succeeded, return JSONObject with no NetworkError
        return (wouldBeJSON, nil)
    }
    
    //Use this Method when recieving Data from a server
    static func toSwift(with JSON: Data) -> (swiftObject: AnyObject?, error: NetworkError?){
        var wouldBeSwift: AnyObject? = nil
        do{ wouldBeSwift = try JSONSerialization.jsonObject(with: JSON, options: .allowFragments) as AnyObject}
        //Conversion failed, return nil with NetworkError.
        catch{return (wouldBeSwift, NetworkError.DataToJSON)}
        //Conversion Succeeded, return Swift Object with no NetworkError
        return (wouldBeSwift, nil)
    }
    
    static func toUdacitySecured(_ data: Data) -> Data?{
        guard (data.count > 5) else{print("Data does not meet Udacity's security protocol!");return nil}
        let range = Range(uncheckedBounds: (5, data.count))
        let securedData = data.subdata(in: range)
        return securedData
    }
    
    //For easy conversion of degrees to radians represented by a CGFloat.
    static func toRadians(_ withDegrees: Double) -> CGFloat{
        return CGFloat(withDegrees * .pi / withDegrees)
    }
}

struct OTMColor{
    var teal: UIColor{get{return UIColor(red: decimal(3), green: decimal(139), blue: decimal(158), alpha: 1)}}
    var lightTeal: UIColor{get{return UIColor(red: decimal(8), green: decimal(144), blue: decimal(163), alpha: 1)}}
    var red: UIColor{get{return UIColor(red: decimal(245), green: decimal(23), blue: decimal(18), alpha: 1)}}
    var white: UIColor{get{return UIColor(red: decimal(241), green: decimal(241), blue: decimal(241), alpha: 1)}}
    var gray: UIColor{get{return UIColor.darkGray}}
    private func decimal(_ rgbValue: Int) -> CGFloat{return CGFloat(rgbValue)/CGFloat(255)}
}

extension String{
    //Checks for blank space as well as Empty
    var isBlank: Bool{return trimmingCharacters(in: .whitespaces).isEmpty}
    //Adds an HTTP formated prefix if not already existing.
    var prefixHTTP: String{return (self.hasPrefix("http") ? self : "http://\(self)")}
}









