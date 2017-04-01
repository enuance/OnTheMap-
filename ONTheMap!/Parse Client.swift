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
    
    class func postUserLocation(user: Student, completionHandler: @escaping (_ objectID: String?, _ error: NetworkError?)-> Void){
        let domainName = "postUserLocation(:_)"
        guard user.isPostable else{return completionHandler( nil, NetworkError.invalidPostingData(domain: domainName, data: "User Info"))}
        let request = NSMutableURLRequest(url: URLCnst.fromParse())
        let httpHeader = [
            ParseCnst.headerAPIKey : ParseCnst.headerAPIValue,
            ParseCnst.headerAppIDKey:ParseCnst.headerAppIDValue,
            PostHeader.ContentTypeKey : PostHeader.appAndCharSetValue]
        let httpBody: [String : Any] = [
            StudentCnst.uniqueKey : user.uniqueKey!,
            StudentCnst.firstName: user.firstName,
            StudentCnst.lastName: user.lastName,
            StudentCnst.mediaURL : user.mediaURL,
            StudentCnst.mapString : user.mapString,
            StudentCnst.longitude : user.longitude,
            StudentCnst.latitude : user.latitude]
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
            
            //Extract the objectID through the completion handler.
            return completionHandler(objectId, nil)
        }
        task.resume()
    }
    
    ///MARK: Method Needs Testing!!!!.....................................................................................
    class func updateUserLocation(user: Student, completionHandler: @escaping(_ updated: Bool?, _ error: NetworkError?)-> Void ){
        let domainName = "updateUserLocation(:_)"
        guard user.isPostable && user.isValid
            else{return completionHandler( nil, NetworkError.invalidPutData(domain: domainName, data: "User Info"))}
        let request = NSMutableURLRequest(url: URLCnst.fromParse(nil, user.objectId))
        let httpHeader = [
            ParseCnst.headerAPIKey : ParseCnst.headerAPIValue,
            ParseCnst.headerAppIDKey : ParseCnst.headerAppIDValue,
            PostHeader.ContentTypeKey : PostHeader.appAndCharSetValue]
        let httpBody: [String : Any] = [
            StudentCnst.uniqueKey : user.uniqueKey!,
            StudentCnst.firstName: user.firstName,
            StudentCnst.lastName: user.lastName,
            StudentCnst.mediaURL : user.mediaURL,
            StudentCnst.mapString : user.mapString,
            StudentCnst.longitude : user.longitude,
            StudentCnst.latitude : user.latitude]
        let httpBodyData = ConvertObject.toJSON(with: httpBody as AnyObject)
        guard let httpJSONBody = httpBodyData.JSONObject else {return completionHandler(nil, httpBodyData.error!)}
        
        request.httpMethod = MethodType.put
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
            guard let updatedResponse = resultsObject as? [String:Any],
                let updateDate = updatedResponse[ParseCnst.updated] as? String
                else {return completionHandler(nil, NetworkError.invalidAPIPath(domain: domainName))}
            let updateSuccess = !updateDate.isBlank
            
            //Extract the objectID through the completion handler.
            return completionHandler(updateSuccess, nil)
        }
        task.resume()
    }
    
    class func deleteUserLocation(user: Student, completionHandler: @escaping(_ deleted: Bool?, _ error: NetworkError?)-> Void ){
        let domainName = "deleteUserLocation(:_)"
        //Not absolutely necessary to check for validity/postability as all that is needed is object ID.
        guard user.isPostable && user.isValid
            else{return completionHandler( nil, NetworkError.invalidDeleteData(domain: domainName, data: "User Info"))}
        let request = NSMutableURLRequest(url: URLCnst.fromParse(nil, user.objectId))
        let httpHeader = [
            ParseCnst.headerAPIKey : ParseCnst.headerAPIValue,
            ParseCnst.headerAppIDKey:ParseCnst.headerAppIDValue]
        request.httpMethod = MethodType.delete
        request.allHTTPHeaderFields = httpHeader
        
        let task = OnTheMap.shared.session.dataTask(with: request as URLRequest){ data, response, error in
            guard (error == nil) else{ return completionHandler(nil, NetworkError.general)}
            //Allow only OK Status to continue
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299
                else{ return completionHandler(nil, NetworkError.nonOKHTTP(status: (response as! HTTPURLResponse).statusCode))}
            //No data is returned from this method. Making it this far means successful deletion.
            return completionHandler(true, nil)
        }
        task.resume()
    }
    
    class func checkExistingUserLocation(user: Student, completionHandler: @escaping(_ existing: Bool?, _ existingUser: Student?, _ error: NetworkError?)-> Void){
        let domainName = "checkExistingUserLocation(:_)"
        guard user.isPostable
            else{return completionHandler( nil, nil, NetworkError.invalidPostingData(domain: domainName, data: "User Info"))}
        let searchItems = [StudentCnst.uniqueKey : user.uniqueKey!]
        let request = NSMutableURLRequest(url: URLCnst.fromParse(searchItems))
        let httpHeader = [
            ParseCnst.headerAPIKey : ParseCnst.headerAPIValue,
            ParseCnst.headerAppIDKey:ParseCnst.headerAppIDValue]
        request.httpMethod = MethodType.get
        request.allHTTPHeaderFields = httpHeader
        
        let task = OnTheMap.shared.session.dataTask(with: request as URLRequest){ data, response, error in
            guard (error == nil) else{ return completionHandler(nil, nil, NetworkError.general)}
            //Allow only OK Status to continue
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299
                else{ return completionHandler(nil, nil, NetworkError.nonOKHTTP(status: (response as! HTTPURLResponse).statusCode))}
            //Exit method if no data is present.
            guard let data = data else{return completionHandler(nil, nil, NetworkError.noDataReturned(domain: domainName))}
            //Convert the data into Swift's AnyObject Type
            let results = ConvertObject.toSwift(with: data)
            //Exit the method if the conversion returns a conversion error
            guard let resultsObject = results.swiftObject else {return completionHandler(nil, nil, results.error)}
            //Validate the expected object to be recieved as an array of dictionaries
            guard let studentsList = resultsObject[ParseCnst.returnedResults] as? [[String:Any]]
                else {return completionHandler(nil, nil, NetworkError.invalidAPIPath(domain: domainName))}
            //Validate that the array that has been recieved actually contains something
            guard studentsList.isEmpty == false else{return completionHandler(false, nil, nil)}
            
            //Start inputing valid student info into local array and extract through the completion handler
            var validatedList = [Student]()
            for students in studentsList{
                let aStudent = Student()
                for (key, value) in students{ aStudent.setPropertyBy(key, with: value)}
                if aStudent.isValid && aStudent.isPostable{validatedList.append(aStudent)}
            }
            
            guard (validatedList.count >= 1) else{return completionHandler(false, nil, nil)}
            //returns the first user that meets the unique key criteria.
            let recentExistingUser = validatedList[0]
            return completionHandler(true, recentExistingUser, nil)
        }
        task.resume()
    }
}
