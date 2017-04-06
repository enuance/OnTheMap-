//
//  OTM! Login Controller.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 3/3/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

class OTMLoginController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var OTMPin: UIImageView!
    @IBOutlet weak var OTMLogo: UIImageView!
    
    @IBOutlet weak var loginTray: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet var udacityLogin: UIView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var createUserAccnt: UIButton!
    @IBOutlet weak var cancelDot: UIButton!
    
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    
    override func viewDidLoad() { super.viewDidLoad()
        if let visualEffect = visualEffect{visualEffect.effect = nil}
        userNameField.delegate = self
        passwordField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {super.viewWillAppear(true)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(true)
        animateLoginScreen()
    }
    
    @IBAction func showUdacityLoginView(_ sender: UIButton) {
        udacityLogin.translatesAutoresizingMaskIntoConstraints = true
        view.addSubview(udacityLogin)
        udacityLogin.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        udacityLogin.autoresizingMask = [
            UIViewAutoresizing.flexibleLeftMargin,
            UIViewAutoresizing.flexibleRightMargin,
            UIViewAutoresizing.flexibleTopMargin,
            UIViewAutoresizing.flexibleBottomMargin
        ]
        UIView.animate(withDuration: 0.8){
            if let visualEffect = self.visualEffect{visualEffect.effect = UIBlurEffect(style: UIBlurEffectStyle.light)}
            self.udacityLogin.alpha = 1
            self.OTMLogo.alpha = 0
            self.loginTray.transform = CGAffineTransform.identity
            self.loginButton.transform = CGAffineTransform.identity
            self.OTMPin.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func removeUdacityLoginView(_ sender: UIButton) {
        UIView.animate(withDuration: 0.8, animations: ({
            self.udacityLogin.alpha = 0
            if let visualEffect = self.visualEffect{visualEffect.effect = nil}
        })){ successfulCompletion in
            self.udacityLogin.removeFromSuperview()
            self.animateLoginScreen()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if userNameField.text == nil || userNameField.text!.isBlank{userNameField.becomeFirstResponder() ;return false}
        if passwordField.text == nil || passwordField.text!.isBlank{passwordField.becomeFirstResponder() ;return false}
        textField.resignFirstResponder()
        return true
    }
    
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


























extension OTMLoginController{
    
    func animateLoginScreen(){
        UIView.animate(withDuration: 0.8, animations: ({
            self.OTMLogo.alpha = 1
            self.loginTray.transform = CGAffineTransform(translationX: 0, y: -(self.loginButton.frame.height * 1.25))
            self.loginButton.transform = CGAffineTransform(rotationAngle: ConvertObject.toRadians(180))
        })){ successfulCompletion in
            self.animatePinDrop()
        }
    }
    
    func animatePinDrop(){
        //Gives the dropped pin a springing effect once dropped.
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveLinear, animations: ({
            self.OTMPin.transform = CGAffineTransform(translationX: 0, y:(self.OTMPin.frame.height * 2.25))
        }), completion: nil)
    }
    
    
}
