//
//  KeyBoardManagement.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/10/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//
/*
 This Keyboard Management File Contains extensions that hold the Keyboard Notification Subscription methods for various Controllers
 throughout the app. The notable difference between the Keyboard Will Show methods are the Scaler/Buffer values wich have been
 chosen in order to clear high profile elements within their View Controller so that they remain visible and give the user context
 while typing.
 */

import UIKit

extension OTMLoginController{
    func keyboardWillShow(_ notification: Notification){
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{return}
        let clearanceScaler = CGFloat(userNameField.isEditing ? 2 : 1)
        if udacityLogin.frame.intersects(keyboardFrame){
            let moveBy = udacityLogin.frame.intersection(keyboardFrame)
            view.frame.origin.y = 0 - (moveBy.height / clearanceScaler)
        }
    }
    func keyboardWillHide(notification: NSNotification) {if view.frame.origin.y != 0 {view.frame.origin.y = 0}}
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

extension LocationViewController{
    func keyboardWillShow(_ notification: Notification){
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{return}
        let clearanceBuffer: CGFloat = 0.75
        if locationTextField.frame.intersects(keyboardFrame){
            let moveBy = messageView.frame.intersection(keyboardFrame)
            view.frame.origin.y = 0 - (moveBy.height * clearanceBuffer)
        }
    }
    func keyboardWillHide(notification: NSNotification) {if view.frame.origin.y != 0 {view.frame.origin.y = 0}}
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

extension PostViewController{
    func keyboardWillShow(_ notification: Notification){
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{return}
        let clearanceBuffer: CGFloat = 0.5
        if entryView.frame.intersects(keyboardFrame){
            let moveBy = linkAndPostView.frame.intersection(keyboardFrame)
            view.frame.origin.y = 0 - (moveBy.height * clearanceBuffer)
        }
    }
    func keyboardWillHide(notification: NSNotification) {if view.frame.origin.y != 0 {view.frame.origin.y = 0}}
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}




