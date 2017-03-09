//
//  Authentication Clients.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 3/8/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import Foundation
import UIKit

class udaClient{
    class func authenticate(userName: String, passWord: String, completionHandler: @escaping (_ registered: Bool?, _ sessionID: String?) -> Void){
        
        let request = NSMutableURLRequest(url: URLCnst.fromUdacity())
        let httpHeader = [PostHeader.ContentTypeKey : PostHeader.appAndCharSetValue]
        let httpBody = ["udacity":["username": userName, "password": passWord]]
        let httpBodyData = ConvertObject.toJSON(with: httpBody as AnyObject)
        guard let httpJSONBody = httpBodyData.JSONObject else { print(httpBodyData.error!); return}
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = httpHeader
        request.httpBody = httpJSONBody
        
        let task = OnTheMap.shared.session.dataTask(with: request as URLRequest){ data, response, error in
            //TO DO: Implement the data task!
        }
    }
    
}

class fbClient{
    
}
