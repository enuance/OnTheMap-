//
//  Error Handling.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 3/18/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import Foundation
import UIKit

enum NetworkError: LocalizedError{
    case general
    case invalidLogIn
    case JSONToData
    case DataToJSON
    case emptyObject(domain: String)
    case nonOKHTTP(status: Int)
    case noDataReturned(domain: String)
    case invalidAPIPath(domain: String)
    case invalidPostingData(domain: String, data: String)
    case invalidPutData(domain: String, data: String)
    case invalidDeleteData(domain: String, data: String)
    
    var localizedDescription: String{
        switch self{
        case .general:
            return "The task could not be completed due to a Network Request Error"
        case .invalidLogIn:
            return "Invalid Password/Username Combination"
        case .JSONToData:
            return "Error with converting Swift Object to JSON Object (DATA), check values!"
        case .DataToJSON:
            return "Error with converting JSON Object (DATA) to Swift Object, check values!"
        case .emptyObject(domain: let method):
            return "An empty object/No content was returned by \(method)"
        case .nonOKHTTP(status: let statusNumber):
            return "A Non 2XX (OK) HTTP Status code of \(statusNumber) was given"
        case .noDataReturned(domain: let method):
            return "No data was returned from \(method)"
        case .invalidAPIPath(domain: let method):
            return "The API Structure Does not match the expected path traversed in \(method)"
        case .invalidPostingData(domain: let method, data: let description):
            return "The invalid data: \(description) was rejected from \(method)"
        case .invalidPutData(domain: let method, data: let description):
            return "The invalid data: \(description) was rejected from \(method)"
        case .invalidDeleteData(domain: let method, data: let description):
            return "The invalid data: \(description) was rejected from \(method)"        }
    }
}

enum GeneralError: String{
    case UIConnection = "User Interface ConnectionError"
    case invalidURL = "Invalid URL"
    
    var description: String{
        switch self{
        case .UIConnection:
            return "This Interface did not get connected properly and is unable to complete the assigned task."
        case .invalidURL:
            return "You have attempted to open an invalid URL"
        }
    }
}


class SendError{
    class func toDisplay(_ displayer: UIViewController, errorType: String, errorMessage: String, assignment: (() -> Void)?) {
        let errorColor = UIColor(red: CGFloat(0.007), green: CGFloat(0.537), blue: CGFloat(0.635), alpha: CGFloat(1))
        let errorTypeString = NSAttributedString(string: errorType, attributes: [
            NSFontAttributeName : UIFont(name: "Avenir Next Medium", size: CGFloat(16))!,
            NSForegroundColorAttributeName : errorColor
            ])
        let messageString = NSAttributedString(string: errorMessage, attributes: [
            NSFontAttributeName : UIFont(name: "Avenir Next", size: CGFloat(12))!,
            NSForegroundColorAttributeName : UIColor.darkGray
            ])
        let errorAlert = UIAlertController(title: errorType, message: errorMessage, preferredStyle: .alert)
        errorAlert.setValue(errorTypeString, forKey: "attributedTitle")
        errorAlert.setValue(messageString, forKey: "attributedMessage")
        
        let dismissError = UIAlertAction(title: "Dismiss", style: .default) { action in
            errorAlert.dismiss(animated: true)
            if let assignment = assignment{assignment()}
        }
        errorAlert.addAction(dismissError)
        
        let subview = errorAlert.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.layer.cornerRadius = 10
        alertContentView.layer.borderWidth = CGFloat(0.5)
        alertContentView.layer.borderColor = errorColor.cgColor
        
        errorAlert.view.tintColor = errorColor
        displayer.present(errorAlert, animated: true, completion: nil)
    }
    
}
