//
//  OTM! Login Controller.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 3/3/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

class OTMLoginController: UIViewController {

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
    }
    
    
    
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
        UIView.animate(withDuration: 0.35){
            self.OTMPin.transform = CGAffineTransform(translationX: 0, y:(self.OTMPin.frame.height * 2.25))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateLoginScreen()
    }
    
    @IBAction func showUdacityLoginView(_ sender: UIButton) {
        udacityLogin.translatesAutoresizingMaskIntoConstraints = true
        view.addSubview(udacityLogin)
        udacityLogin.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        udacityLogin.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
        
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
    
    
}

