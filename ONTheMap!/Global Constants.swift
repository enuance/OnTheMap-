//
//  Global Constants.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 3/3/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//
/*
This file contains the constant values that will be used widely throughout the application and are placed here for easy access and referencing as well as to avoid Magic Numbers. All Structs and Objects will contain the suffix Cnst (Standing for Constant).
*/


import Foundation
import UIKit

//These Parse API Values are publically used by other Udacity Student and thus can be overwritten at any time.
struct ParseCnst {
    //The Parse API Base URL
    static let baseURL = "https://parse.udacity.com/parse/classes"
    //The API Key and Value
    static let headerAPIKey = "X-Parse-REST-API-Key"
    static let headerAPIValue = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    //The Application ID Key and Value
    static let headerAppIDKey = "X-Parse-Application-Id"
    static let headerAppIDValue = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"

    static let methdStudentLocation = "/StudentLocation"
    //static let methd
}

struct UdacityCnst{
    
    
}

struct PostHeader {
    static let ContentTypeKey = "Content-Type"
    static let appAndCharSetValue = "application/json;charset=utf-8"
}
