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
    
    //......................!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ///MARK: TO DO
    static func fromParseWith(_ parameters: [String : Any]) -> URL{ //THIS METHOD NEEDS TO BE TESTED!!!!!!!!
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
    
    //The Udacity URL is much more uniform, having only one URL needed in this app.
    static func fromUdacity(_ withUserID: String? = nil) -> URL{
        var components = URLComponents()
        components.scheme = "https"
        components.host = UdacityCnst.apiHostURL
        components.path = UdacityCnst.apiPath + ( withUserID != nil ? (UdacityCnst.methdGetUserInfo + withUserID!) : UdacityCnst.methdSessionID)
        return components.url!
    }
}


///MARK: refactor the convert Obj Struct to implement the Network Error Type!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
///MARK: refactor the convert Obj Struct to implement the Network Error Type!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
///MARK: refactor the convert Obj Struct to implement the Network Error Type!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
struct ConvertObject{
    //Use This Method when sending Data to a server
    static func toJSON(with object: AnyObject) -> (JSONObject: Data?, error: String?){
        //PlaceHolder Variable for JSONObject
        var wouldBeJSON: Data? = nil
        //Converting object parameter into JSONObject so that it could be sent and understood by the server.
        do{ wouldBeJSON = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)}
        catch{
            //Conversion failed, return nil with error string.
            return (wouldBeJSON,"Error with converting object passed in parameter to JSONObject, check values!")
        }
        //Conversion Succeeded, return JSONObject with no error string
        return (wouldBeJSON, nil)
    }
    
    //Use this Method when recieving Data from a server
    static func toSwift(with JSON: Data) -> (swiftObject: AnyObject?, error: String?){
        //PlaceHolder Variable for JSONObject
        var wouldBeSwift: AnyObject? = nil
        //Converting JSON parameter into Swift Object so that it could be parsed by our app.
        do{ wouldBeSwift = try JSONSerialization.jsonObject(with: JSON, options: .allowFragments) as AnyObject}
        catch{
            //Conversion failed, return nil with error string.
            return (wouldBeSwift, "Error with converting JSON passed in parameter to Swift Object, check values!")
        }
        //Conversion Succeeded, return Swift Object with no error string
        return (wouldBeSwift, nil)
    }
    
    static func toUdacitySecured(_ data: Data) -> Data?{
        guard (data.count > 5) else{print("Data does not meet Udacity's security protocol!");return nil}
        let range = Range(uncheckedBounds: (5, data.count))
        let securedData = data.subdata(in: range)
        return securedData
    }
    
}











