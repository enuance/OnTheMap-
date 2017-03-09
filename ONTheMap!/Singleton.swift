//
//  Singleton.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 3/8/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import Foundation

class OnTheMap{
    
    //Shared URL Session for the App.
    let session = URLSession.shared
    
    //Singleton instance for the OnTheMap Class
    static let shared = OnTheMap()
    private init(){}
}
