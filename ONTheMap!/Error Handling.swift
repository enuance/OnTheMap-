//
//  Error Handling.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 3/18/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import Foundation

enum NetworkError: Error, LocalizedError{
    case invalidLogIn
    case JSONToData
    case DataToJSON
    case nonOKHTTP(status: Int)
    case noDataReturned(domain: String)
    case invalidAPIPath(domain: String)
    
    var localizedDescription: String{
        switch self{
        case .invalidLogIn:
            return "Invalid Password/Username Combination"
        case .JSONToData:
            return "Error with converting Swift Object to JSON Object (DATA), check values!"
        case .DataToJSON:
            return "Error with converting JSON Object (DATA) to Swift Object, check values!"
        case .nonOKHTTP(status: let statusNumber):
            return "A Non 2XX (OK) HTTP Status code of \(statusNumber) was given"
        case .noDataReturned(domain: let method):
            return "No data was returned from \(method)"
        case .invalidAPIPath(domain: let method):
            return "The API Structure Does not match the expected path traversed in \(method)"
        }
    }
}



//Testing function to test the calling of the NewtorkError Type. Delete when done!
func ijsdfbnvoajdfbv(){
    let monkeyWrench: Error = NetworkError.invalidAPIPath(domain: "theSpecialFunc")
    print(monkeyWrench.localizedDescription)
}
