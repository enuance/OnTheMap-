//
//  KeyBoardManagement.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/10/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import Foundation
import UIKit

extension OTMLoginController{
    
    func keyboardWillShow(_ notification: Notification){
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else{print("Keyboard size not accesible"); return}
        let clearanceScaler = CGFloat(userNameField.isEditing ? 2 : 1)
        if udacityLogin.frame.intersects(keyboardFrame){
            let moveBy = udacityLogin.frame.intersection(keyboardFrame)
            view.frame.origin.y = 0 - (moveBy.height / clearanceScaler)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {view.frame.origin.y = 0}
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
