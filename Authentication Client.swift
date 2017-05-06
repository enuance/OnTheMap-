//
//  Authentication Client.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 3/8/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//
/*
 This File contains the Networking methods for the Udacity API. These Methods allow us to Authenticate the user, pull basic user information, and logout of the app. All of these methods work asyncronously and the completion handlers do not return data onto the main thread.
 */

import Foundation

class udaClient{
    class func authenticate(userName: String, passWord: String, completionHandler: @escaping (_ userAcctID: String?, _ sessionID: String?, _ error: NetworkError?) -> Void){
        let domainName = "udaClient.authenticate(:_)"
        let request = NSMutableURLRequest(url: URLCnst.fromUdacity())
        let httpHeader = [PostHeader.ContentTypeKey : PostHeader.appAndCharSetValue]
        let httpBody = ["udacity":["username": userName, "password": passWord]]
        let httpBodyData = ConvertObject.toJSON(with: httpBody as AnyObject)
        guard let httpJSONBody = httpBodyData.JSONObject else {return completionHandler(nil, nil, httpBodyData.error!)}
        request.httpMethod = MethodType.post
        request.allHTTPHeaderFields = httpHeader
        request.httpBody = httpJSONBody
        
        let task = OnTheMap.shared.session.dataTask(with: request as URLRequest){ data, response, error in
            guard (error == nil) else{ return completionHandler(nil, nil, NetworkError.general)}
            //Allow only OK or forbidden Status' to continue
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 || statusCode == 403
                else{ return completionHandler(nil, nil, NetworkError.nonOKHTTP(status: (response as! HTTPURLResponse).statusCode))}
            //Capture the forbidden Status and return invalidLogIn to the completion handler.
            guard (statusCode != 403) else {return completionHandler(nil, nil, NetworkError.invalidLogIn)}
            //Exit method if no data is present.
            guard let data = data, let authData = ConvertObject.toUdacitySecured(data)
                else{return completionHandler(nil, nil, NetworkError.noDataReturned(domain: domainName))}
            //Convert the data into Swift's AnyObject Type
            let authObject = ConvertObject.toSwift(with: authData)
            //Exit the method if the conversion returns a conversion error
            guard let swiftAuthObj = authObject.swiftObject else {return completionHandler(nil, nil, authObject.error)}
            //Otherwise navigate through the object and extract data through the completion handler
            guard let authDictionary = swiftAuthObj as? [String : AnyObject],
                let accntInfo = authDictionary[UdacityCnst.accntDictName] as? [String : AnyObject],
                let userID = accntInfo[UdacityCnst.accntIDKey] as? String,
                let sessionInfo = authDictionary[UdacityCnst.sessionDictName] as? [String : AnyObject],
                let sessionNumber = sessionInfo[UdacityCnst.sessionIDKey] as? String
                else{return completionHandler(nil, nil, NetworkError.invalidAPIPath(domain: domainName))}
            return completionHandler(userID, sessionNumber, nil)
        }
        task.resume()
    }
    
    class func getPublicUserInfo(userAcctID: String, completionHandler: @escaping (_ firstName: String?, _ lastName: String?, _ error: NetworkError?) -> Void){
        let domainName = "udaClient.getPublicUserInfo(:_)"
        let request = NSMutableURLRequest(url: URLCnst.fromUdacity(userAcctID))
        request.httpMethod = MethodType.get
        
        let task = OnTheMap.shared.session.dataTask(with: request as URLRequest){ data, response, error in
            guard (error == nil) else{return completionHandler(nil, nil, NetworkError.general)}
            //Allow only OK status to continue
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299
                else{return completionHandler(nil, nil, NetworkError.nonOKHTTP(status: (response as! HTTPURLResponse).statusCode))}
            //Exit method if no data is present.
            guard let data = data, let userData = ConvertObject.toUdacitySecured(data)
                else{return completionHandler(nil, nil, NetworkError.noDataReturned(domain: domainName))}
            //Convert the data into Swift's AnyObject Type
            let userObject = ConvertObject.toSwift(with: userData)
            //Exit the method if the conversion returns a conversion error
            guard let swiftUserObj = userObject.swiftObject else {return completionHandler(nil, nil, userObject.error)}
            //Otherwise navigate through the object and extract data through the completion handler
            guard let userDictionary = swiftUserObj as? [String : AnyObject],
                let userInfo = userDictionary[UdacityCnst.user] as? [String : AnyObject],
                let userFirstName = userInfo[UdacityCnst.firstName] as? String,
                let userLastName = userInfo[UdacityCnst.lastName] as? String
                else{return completionHandler(nil, nil, NetworkError.invalidAPIPath(domain: domainName))}
            return completionHandler(userFirstName, userLastName, nil)
        }
        task.resume()
    }
    
    class func logout(completionHandler: @escaping (_ success: Bool?, _ logoutID: String?, _ error: NetworkError?) -> Void){
        let domainName = "udaClient.logout(:_)"
        let request = NSMutableURLRequest(url: URLCnst.fromUdacity())
        request.httpMethod = MethodType.delete
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies!{if cookie.name == UdacityCnst.cookieName{ xsrfCookie = cookie; print("Deleting: \(cookie)")}}
        if let xsrfCookie = xsrfCookie{request.setValue(xsrfCookie.value, forHTTPHeaderField: UdacityCnst.cookieHeaderField)}
        
        let task = OnTheMap.shared.session.dataTask(with: request as URLRequest){ data, response, error in
            guard (error == nil) else{return completionHandler(nil, nil, NetworkError.general)}
            //Allow only OK status to continue
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299
                else{return completionHandler(nil, nil, NetworkError.nonOKHTTP(status: (response as! HTTPURLResponse).statusCode))}
            //Exit method if no data is present.
            guard let data = data, let logoutData = ConvertObject.toUdacitySecured(data)
                else{return completionHandler(nil, nil, NetworkError.noDataReturned(domain: domainName))}
            //Convert the data into Swift's AnyObject Type
            let logoutObject = ConvertObject.toSwift(with: logoutData)
            //Exit the method if the conversion returns a conversion error
            guard let swiftLogObj = logoutObject.swiftObject else {return completionHandler(nil, nil, logoutObject.error)}
            //Otherwise navigate through the object and extract data through the completion handler
            guard let logoutDictionary = swiftLogObj as? [String : AnyObject],
                let logoutInfo = logoutDictionary[UdacityCnst.sessionDictName] as? [String : AnyObject],
                let logoutNumber = logoutInfo[UdacityCnst.sessionIDKey] as? String
                else{return completionHandler(nil, nil, NetworkError.invalidAPIPath(domain: domainName))}
            return completionHandler(true, logoutNumber, nil)
        }
        task.resume()
    }
    
}
