//
//  Error Handling.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 3/18/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError{
    case general
    case invalidLogIn
    case JSONToData
    case DataToJSON
    case nonOKHTTP(status: Int)
    case noDataReturned(domain: String)
    case invalidAPIPath(domain: String)
    
    var localizedDescription: String{
        switch self{
        case .general:
            return "NetWork Error: The task could not be completed due to a Network Request Error"
        case .invalidLogIn:
            return "NetWork Error: Invalid Password/Username Combination"
        case .JSONToData:
            return "NetWork Error: Error with converting Swift Object to JSON Object (DATA), check values!"
        case .DataToJSON:
            return "NetWork Error: Error with converting JSON Object (DATA) to Swift Object, check values!"
        case .nonOKHTTP(status: let statusNumber):
            return "NetWork Error: A Non 2XX (OK) HTTP Status code of \(statusNumber) was given"
        case .noDataReturned(domain: let method):
            return "NetWork Error: No data was returned from \(method)"
        case .invalidAPIPath(domain: let method):
            return "NetWork Error: The API Structure Does not match the expected path traversed in \(method)"
        }
    }
}
