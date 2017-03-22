//
//  Parse Client.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 3/17/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import Foundation

//In parse returned JSON object is a Dictionary [String : Any]. The key is a String called "results" and the value is Type Any which can be downcasted to an Array of Any objects ["results" : Any as [Any]]. The type Any inside of the Array can be downcasted into the dictionary type ["results" : Any as [Any as [String : Any]]]. This dictionary represents our Student type to be extracted and contains a Key String : Value Any pair.

//If we paginate past the total amount of objects contained in the database, then the results key will return a value equal to an empty array
class ParseClient{
    //a Method to refresh and fill the locations array in the OnTheMap Singleton
    class func locationsRefresh(){
        //Declare After getStudents
    }
    
    class func getStudents(limit: Int, skip: Int, completionHandler: @escaping (_ validStudents: [Student]?, _ error: NetworkError?)-> Void){
        let domainName = "ParseClient.getStudents(:_)"
        
        let parameters:[String: Any] = [
            ParseCnst.parameterLimit : limit,
            ParseCnst.parameterSkip: skip,
            ParseCnst.parameterOrder : ParseCnst.parameterOrderValue]
        
        let request = NSMutableURLRequest(url: URLCnst.fromParseWith(parameters))
        let httpHeader = [ParseCnst.headerAPIKey : ParseCnst.headerAPIValue, ParseCnst.headerAppIDKey:ParseCnst.headerAppIDValue]
        
        request.httpMethod = MethodType.get
        request.allHTTPHeaderFields = httpHeader
        
        let task = OnTheMap.shared.session.dataTask(with: request as URLRequest){ data, response, error in
         
            ///FINISH IMPLEMENTING THIS!!!!!!!
            
            
        }
        task.resume()
        
    }
}
