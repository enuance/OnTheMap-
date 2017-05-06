//
//  TextFieldManagement.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 5/5/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//
/*
 This File contains all of the text field delegation methods throughout the app
 */

import UIKit

extension OTMLoginController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if userNameField.text == nil || userNameField.text!.isBlank{userNameField.becomeFirstResponder() ;return false}
        if passwordField.text == nil || passwordField.text!.isBlank{passwordField.becomeFirstResponder() ;return false}
        OnTheMap.shared.userName = userNameField.text!; OnTheMap.shared.userPassword = passwordField.text!
        textField.resignFirstResponder()
        userNameField.text = ""; passwordField.text = ""
        showPendingLoginTask()
        return true
    }
}

extension LocationViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let entry = textField.text ?? ""
        if entry.isBlank{
            textField.resignFirstResponder()
            SendToDisplay.error(self, errorType: "Text Field is Blank", errorMessage: "Please enter a location for us to search.", assignment: nil)
            return true
        }else{
            geoCodeEntry(entry: entry)
            textField.resignFirstResponder()
            return true
        }
    }
}

extension PostViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let entryText = textField.text ?? ""
        if entryText.isBlank{
            textField.resignFirstResponder()
            SendToDisplay.error(self, errorType: "Text Field is Blank", errorMessage: "Please enter a web link for us to share.", assignment: nil)
            return true
        }
        let formatedEntry = entryText.prefixHTTP
        if let formattedEntry = URL(string: formatedEntry){
            mediaLinkToShare = formattedEntry.absoluteString
            textField.resignFirstResponder()
            animatePostItButton()
            return true
        }else{
            textField.resignFirstResponder()
            textField.text = ""
            SendToDisplay.error(self, errorType: "Invalid URL Format", errorMessage: "You have attempted to share an improperly formatted URL", assignment: nil)
            return true
        }
    }
}
