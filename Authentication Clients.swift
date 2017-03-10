//
//  Authentication Clients.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 3/8/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import Foundation
import UIKit


///MARK: TO DO/ Test Auth Method before moving on!!!!!!!!!!!!!!!!!!!!!!!!!!
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
            guard (error == nil) else{print("udaClient.authenticate(:_) returned Data Task Error: \(error)") ;return}
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else{print("HTTP Status Code is non 2XX");return}
            guard let data = data else{print("udaClient.authenticate(:_) returned no data"); return}
            let range = Range(uncheckedBounds: (5, data.count - 5))
            let authData = data.subdata(in: range)
            let authObject = ConvertObject.toSwift(with: authData)
            guard let swiftAuthObj = authObject.swiftObject else {print(authObject.error!); return}
            guard let authDictionary = swiftAuthObj as? [String : AnyObject] else{print("Unexpected Object Structure") ;return}
            
            guard let accntInfo = authDictionary[UdacityCnst.accntDictName] as? [String : AnyObject],
                let registration = accntInfo[UdacityCnst.accntRegisteredKey] as? Bool else {print("Unexpected Object Structure"); return}
            
            guard let sessionInfo = authDictionary[UdacityCnst.sessionDictName] as? [String : AnyObject],
                let sessionNumber = sessionInfo[UdacityCnst.sessionIDKey] as? String else{print("Unexpected Object Structure"); return}
            
            //Dispatch onto the main queue incase registration and SessionID is used directly with UI elements
            DispatchQueue.main.async {
                return completionHandler(registration, sessionNumber)
            }
        }
        task.resume()
    }
}

class fbClient{
    
}
