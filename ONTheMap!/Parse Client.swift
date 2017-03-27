//
//  Parse Client.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 3/17/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import Foundation

class ParseClient{
    //A recursive method to refresh the OnTheMap Locations property.
    class func locationsRefresh(_ max: Int = ParseCnst.maxLocations, _ skipOver: Int = 0, completionHandler: @escaping(_ locationsCount: Int?, _ error: NetworkError?)->Void){
        let domain = "locationsRefresh(:_)"
        
        ParseClient.getStudents(limit: max, skip: skipOver){stdntList, error in
            guard (error == nil)else{return completionHandler(nil, error)}
            guard let studentList = stdntList else{return completionHandler(nil, NetworkError.noDataReturned(domain: domain))}
            
            
            for students in studentList{OnTheMap.shared.locations.append(students);print("appended: \(students.firstName!)")}
            if !OnTheMap.shared.isFull{
                let newSkip = skipOver + max
                let newMax = max - studentList.count
                //Recursive call with new values: handlers set up so that values can travel back once base case is reached
                locationsRefresh(newMax, newSkip){lastCount , anError in
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
            //Allow only OK or forbidden Status' to continue
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299
                else{ return completionHandler(nil, NetworkError.nonOKHTTP(status: (response as! HTTPURLResponse).statusCode))}
            guard let data = data else{return completionHandler(nil, NetworkError.noDataReturned(domain: domainName))}
            let results = ConvertObject.toSwift(with: data)
            guard let resultsObject = results.swiftObject else {return completionHandler(nil, results.error)}
            guard let studentsList = resultsObject[ParseCnst.returnedResults] as? [[String:Any]] else {return completionHandler(nil, NetworkError.invalidAPIPath(domain: domainName))}
            guard studentsList.isEmpty == false else{return completionHandler(nil, NetworkError.emptyObject(domain: domainName))}
            
            //start navigating results object!!!!
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
    
}
