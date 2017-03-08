//
//  Global Constants.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 3/3/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//
/*
This file contains the constant values that will be used widely throughout the application and are placed here for easy 
access and referencing as well as to avoid Magic Numbers. All Structs and Objects will contain the suffix Cnst (Standing for
Constant).
*/


import Foundation
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
    //For Update Student Location, the HTTP request type would be PUT.
    static let methdUpdateStudentLocation = "/StudentLocation/{ObjectID}"
    //Keys Stated within the Udacity/Parse Documentation.
    static let studentLocKeys = ["objectId","uniqueKey","firstName","lastName","mapString", "mediaURL", "latitude", "longitude"]
}

struct UdacityCnst{
    //The Udacity API Base URL
    static let apiHostURL = "www.udacity.com"
    static let apiPath = "/api"
    //Udacity API Method:
    //To Authenticate set HTTP Request to POST, to logOut set to DELETE.
    static let methdSessionID = "/session"
}

struct PostHeader {
    static let ContentTypeKey = "Content-Type"
    static let appAndCharSetValue = "application/json;charset=utf-8"
}

class URLCnst {
    //parseURL produces a Websafe String to be used as a URL
    //The search query parameter is expects a single key value pair for searching for students by that criteria
    //The Object ID is for use with the PUT type request when updating a students location
    //Both parameters are optional and default to nil, so that they can be ommited if not needed
    class func fromParse(_ searchQuery: [String : Any]? = nil, _ objectID: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = ParseCnst.apiHostURL
        components.path = ParseCnst.apiPath + ParseCnst.methdStudentLocation + (objectID ?? "")
        if let searchQuery = searchQuery{
            components.queryItems = [URLQueryItem]()
            for (key, value) in searchQuery {
                let queryItem = URLQueryItem(name: "where", value: "{\"\(key)\":\"\(value)\"}")
                components.queryItems!.append(queryItem)
            }
        }
        return components.url!
    }
    
    //The Udacity URL is much more uniform, having only one URL needed in this app.
    class func fromUdacity() -> URL{
        var components = URLComponents()
        components.scheme = "https"
        components.host = UdacityCnst.apiHostURL
        components.path = UdacityCnst.apiPath + UdacityCnst.methdSessionID
        return components.url!
    }
}


















