//
//  Authentication Client.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 3/8/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import Foundation


///MARK: Refactor this file to propogate the NetworkError Type!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//Don't mark these as Throws, but rather set the completion handlers to pass the error as on of it's parameters!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
class udaClient{
    
    class func authenticate(userName: String, passWord: String, completionHandler: @escaping (_ registered: Bool?, _ userAcctID: String?, _ sessionID: String?) -> Void){
        
        let request = NSMutableURLRequest(url: URLCnst.fromUdacity())
        let httpHeader = [PostHeader.ContentTypeKey : PostHeader.appAndCharSetValue]
        let httpBody = ["udacity":["username": userName, "password": passWord]]
        let httpBodyData = ConvertObject.toJSON(with: httpBody as AnyObject)
        guard let httpJSONBody = httpBodyData.JSONObject else { print(httpBodyData.error!); return}
        
        request.httpMethod = MethodType.post
        request.allHTTPHeaderFields = httpHeader
        request.httpBody = httpJSONBody
        
        let task = OnTheMap.shared.session.dataTask(with: request as URLRequest){ data, response, error in
            guard (error == nil) else{print("udaClient.authenticate(:_) returned Data Task Error: \(error)") ;return}
            //Allow only OK or forbidden Status' to continue
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 || statusCode == 403
                else{print("HTTP Status Code is non 2XX");return}
            //Capture the forbidden Status and return false to the completion handler.
            guard (statusCode != 403) else {DispatchQueue.main.async {return completionHandler(false, nil, nil)}; return}
            //Exit method if no data is present.
            guard let data = data, let authData = ConvertObject.toUdacitySecured(data)
                else{print("udaClient.authenticate(:_) returned no data"); return}
            //Convert the data into Swift's AnyObject Type
            let authObject = ConvertObject.toSwift(with: authData)
            //Exit the method if the conversion returns an error string
            guard let swiftAuthObj = authObject.swiftObject else {print(authObject.error!); return}
            
            //Otherwise navigate through the object and extract data through the completion handler
            guard let authDictionary = swiftAuthObj as? [String : AnyObject],
                let accntInfo = authDictionary[UdacityCnst.accntDictName] as? [String : AnyObject],
                let registration = accntInfo[UdacityCnst.accntRegisteredKey] as? Bool,
                let userID = accntInfo[UdacityCnst.accntIDKey] as? String,
                let sessionInfo = authDictionary[UdacityCnst.sessionDictName] as? [String : AnyObject],
                let sessionNumber = sessionInfo[UdacityCnst.sessionIDKey] as? String
                else{print("Unexpected Object Structure"); return}
            
            //Dispatch onto the main queue incase registration and SessionID is used directly with UI elements
            DispatchQueue.main.async {return completionHandler(registration, userID, sessionNumber)}
        }
        task.resume()
    }
    
    class func getPublicUserInfo(userAcctID: String, completionHandler: @escaping (_ firstName: String?, _ lastName: String?) -> Void){
        
        let request = NSMutableURLRequest(url: URLCnst.fromUdacity(userAcctID))
        request.httpMethod = MethodType.get
        
        let task = OnTheMap.shared.session.dataTask(with: request as URLRequest){ data, response, error in
            guard (error == nil) else{print("udaClient.getPublicUserInfo(:_) returned Data Task Error: \(error)") ;return}
            //Allow only OK status to continue
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299
                else{print("HTTP Status Code is non 2XX");return}
            //Exit method if no data is present.
            guard let data = data, let userData = ConvertObject.toUdacitySecured(data)
                else{print("udaClient.getPublicUserInfo(:_) returned no data"); return}
            //Convert the data into Swift's AnyObject Type
            let userObject = ConvertObject.toSwift(with: userData)
            //Exit the method if the conversion returns an error string
            guard let swiftUserObj = userObject.swiftObject else {print(userObject.error!); return}
            
            //Otherwise navigate through the object and extract data through the completion handler
            guard let userDictionary = swiftUserObj as? [String : AnyObject],
                let userInfo = userDictionary[UdacityCnst.user] as? [String : AnyObject],
                let userFirstName = userInfo[UdacityCnst.firstName] as? String,
                let userLastName = userInfo[UdacityCnst.lastName] as? String
                else{print("Unexpected Object Structure"); return}
            
            //Dispatch onto the main queue incase registration and SessionID is used directly with UI elements
            DispatchQueue.main.async {return completionHandler(userFirstName, userLastName)}
        }
        task.resume()
    }
    
    class func logout(completionHandler: @escaping (_ success: Bool?, _ logoutID: String?) -> Void){
        
        let request = NSMutableURLRequest(url: URLCnst.fromUdacity())
        request.httpMethod = MethodType.delete
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies!{if cookie.name == UdacityCnst.cookieName{ xsrfCookie = cookie; print("Found XSRF-TOKEN!")}}
        if let xsrfCookie = xsrfCookie{request.setValue(xsrfCookie.value, forHTTPHeaderField: UdacityCnst.cookieHeaderField)}
        
        let task = OnTheMap.shared.session.dataTask(with: request as URLRequest){ data, response, error in
            guard (error == nil) else{print("udaClient.logout(:_) returned Data Task Error: \(error)") ;return}
            //Allow only OK status to continue
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299
                else{print("HTTP Status Code is non 2XX");return}
            //Exit method if no data is present.
            guard let data = data, let logoutData = ConvertObject.toUdacitySecured(data)
                else{print("udaClient.logout(:_) returned no data"); return}
            //Convert the data into Swift's AnyObject Type
            let logoutObject = ConvertObject.toSwift(with: logoutData)
            //Exit the method if the conversion returns an error string
            guard let swiftLogObj = logoutObject.swiftObject else {print(logoutObject.error!); return}
            
            //Otherwise navigate through the object and extract data through the completion handler
            guard let logoutDictionary = swiftLogObj as? [String : AnyObject],
                let logoutInfo = logoutDictionary[UdacityCnst.sessionDictName] as? [String : AnyObject],
                let logoutNumber = logoutInfo[UdacityCnst.sessionIDKey] as? String
                else{print("Unexpected Object Structure"); return}
            
            //Dispatch onto the main queue incase registration and SessionID is used directly with UI elements
            DispatchQueue.main.async {return completionHandler(true, logoutNumber)}
        }
        task.resume()
    }
    
}
