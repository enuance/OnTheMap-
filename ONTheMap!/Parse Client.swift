//
//  Parse Client.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 3/17/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import Foundation

class ParseClient{
    //A recursive convenience method to populate the OnTheMap Locations property.
    class func populateLocations(_ max: Int = ParseCnst.maxLocations, _ skipOver: Int = 0, completionHandler: @escaping(_ locationsCount: Int?, _ error: NetworkError?)->Void){
        let domain = "populateLocations(:_)"
        ParseClient.getStudents(limit: max, skip: skipOver){stdntList, error in
            guard (error == nil)else{return completionHandler(nil, error)}
            guard let studentList = stdntList else{return completionHandler(nil, NetworkError.noDataReturned(domain: domain))}
            for students in studentList{OnTheMap.shared.locations.append(students)}
            if !OnTheMap.shared.isFull{
                let newSkip = skipOver + max
                let newMax = max - studentList.count
                //Recursive call with new values: handlers set up so that values can travel back once base case is reached
                populateLocations(newMax, newSkip){lastCount , anError in
                    guard (anError == nil)else{return completionHandler(nil, anError)}
                    if let lastCount = lastCount{return completionHandler(lastCount, nil)}}}
                //Base Case in recursion for returning completion handler
            else{return completionHandler(OnTheMap.shared.locations.count, nil)}
        }
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
            guard (error == nil) else{ return completionHandler(nil, NetworkError.general)}
            //Allow only OK status to continue
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299
                else{ return completionHandler(nil, NetworkError.nonOKHTTP(status: (response as! HTTPURLResponse).statusCode))}
            //Exit method if no data is present.
            guard let data = data else{return completionHandler(nil, NetworkError.noDataReturned(domain: domainName))}
            //Convert the data into Swift's AnyObject Type
            let results = ConvertObject.toSwift(with: data)
            //Exit the method if the conversion returns a conversion error
            guard let resultsObject = results.swiftObject else {return completionHandler(nil, results.error)}
            //Validate the expected object to be recieved as an array of dictionaries
            guard let studentsList = resultsObject[ParseCnst.returnedResults] as? [[String:Any]]
                else {return completionHandler(nil, NetworkError.invalidAPIPath(domain: domainName))}
            //Validate that the array that has been recieved actually contains something
            guard studentsList.isEmpty == false else{return completionHandler(nil, NetworkError.emptyObject(domain: domainName))}
            
            //Start inputing valid student info into local array and extract through the completion handler
            var validatedList = [Student]()
            for students in studentsList{
                let aStudent = Student()
                for (key, value) in students{ aStudent.setPropertyBy(key, with: value)}
                if aStudent.isValid{validatedList.append(aStudent)}
            }
            return completionHandler(validatedList, nil)
        }
        task.resume()
    }
    
    
    ///MARK: This Method needs to be tested!!!!!!!!!!!!!
    class func postUserLocation(completionHandler: @escaping (_ objectID: String?, _ error: NetworkError?)-> Void){
        let domainName = "postUserLocation(:_)"
        guard OnTheMap.shared.user.isPostable else{return completionHandler( nil, NetworkError.invalidPostingData(domain: domainName, data: "User Info"))}
        let request = NSMutableURLRequest(url: URLCnst.fromParse())
        let httpHeader = [
            ParseCnst.headerAPIKey : ParseCnst.headerAPIValue,
            ParseCnst.headerAppIDKey:ParseCnst.headerAppIDValue,
            PostHeader.ContentTypeKey : PostHeader.appAndCharSetValue]
        let httpBody: [String : Any] = [
            StudentCnst.uniqueKey : OnTheMap.shared.user.uniqueKey!,
            StudentCnst.firstName: OnTheMap.shared.user.firstName,
            StudentCnst.lastName: OnTheMap.shared.user.lastName,
            StudentCnst.mediaURL : OnTheMap.shared.user.mediaURL,
            StudentCnst.mapString : OnTheMap.shared.user.mapString,
            StudentCnst.longitude : OnTheMap.shared.user.longitude,
            StudentCnst.latitude : OnTheMap.shared.user.latitude]
        let httpBodyData = ConvertObject.toJSON(with: httpBody as AnyObject)
         guard let httpJSONBody = httpBodyData.JSONObject else {return completionHandler(nil, httpBodyData.error!)}
        
        request.httpMethod = MethodType.post
        request.allHTTPHeaderFields = httpHeader
        request.httpBody = httpJSONBody
        
        let task = OnTheMap.shared.session.dataTask(with: request as URLRequest){ data, response, error in
            guard (error == nil) else{ return completionHandler(nil, NetworkError.general)}
            //Allow only OK Status to continue
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299
                else{ return completionHandler(nil, NetworkError.nonOKHTTP(status: (response as! HTTPURLResponse).statusCode))}
            //Exit method if no data is present.
            guard let data = data else{return completionHandler(nil, NetworkError.noDataReturned(domain: domainName))}
            //Convert the data into Swift's AnyObject Type
            let results = ConvertObject.toSwift(with: data)
            //Exit the method if the conversion returns a conversion error
            guard let resultsObject = results.swiftObject else {return completionHandler(nil, results.error)}
            
            //Validate the expected object to be recieved as a dictionary and that it contains an objectID String
            guard let responseDictionary = resultsObject as? [String:Any],
            let objectId = responseDictionary[StudentCnst.objectId] as? String
                else {return completionHandler(nil, NetworkError.invalidAPIPath(domain: domainName))}

            return completionHandler(objectId, nil)

        }
        task.resume()
    }
    
    
    
    
    class func updateUserLocation(){
        
    }
    
    //optional - same as update User Locations but with method set to Delete
    class func deleteUserLocation(){
        
    }
    
    class func checkExistingUserLocation(){
        
    }
    
    
    
}
