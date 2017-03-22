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
    
    var locations: [Student]!
    
    //Make sure to test this computed property
    var isFull: Bool{
        guard let locations = locations else{return false}
        return (locations.count >= ParseCnst.maxLocations)
    }
    
    //Shared URL Session for the App.
    let session = URLSession.shared
    
    //Singleton instance for the OnTheMap Class
    static let shared = OnTheMap()
    private init(){}
}
