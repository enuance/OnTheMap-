//
//  Singleton.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 3/8/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import Foundation

class OnTheMap{
    let user = Student()
    var locations = [Student]()
    
    var userName: String!
    var userPassword: String!
    
    //Checks if locations is full up to the max amount.
    var isFull: Bool{return (locations.count >= ParseCnst.maxLocations)}
    //Emptys out the locations list.
    class func clearLocations(){shared.locations = [Student]()}
    //Shared URL Session for the App.
    let session = URLSession.shared
    //Singleton instance for the OnTheMap Class
    static let shared = OnTheMap()
    private init(){}
}
