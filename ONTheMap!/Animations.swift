//
//  Animations.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/10/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import Foundation
import UIKit

//Animation related methods for OTMLoginController
extension OTMLoginController{
    func animateHomeScreen(){
        UIView.animate(withDuration: 0.8, animations: ({
            self.OTMLogo.alpha = 1
            self.loginTray.transform = CGAffineTransform(translationX: 0, y: -(self.loginButton.frame.height * 1.25))
            self.loginButton.transform = CGAffineTransform(rotationAngle: ConvertObject.toRadians(180))
        })){ successfulCompletion in
            //Gives the dropped pin a springing effect once dropped.
            UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveLinear, animations: ({
                self.OTMPin.transform = CGAffineTransform(translationX: 0, y:(self.OTMPin.frame.height * 2.25))
            }), completion: nil)
        }
    }
    
    func animateLoginView(){
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
    
    func animateRemovingLoginView(){
        UIView.animate(withDuration: 0.8, animations: ({
            self.udacityLogin.alpha = 0
            if let visualEffect = self.visualEffect{visualEffect.effect = nil}
        })){ successfulCompletion in
            self.udacityLogin.removeFromSuperview()
            self.animateHomeScreen()
        }
    }
    
    func animateAccountCreation(){
        udacityLogin.alpha = 0
        udacityLogin.removeFromSuperview()
        visualEffect.effect = nil
        let accountCreationController = self.storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        accountCreationController.urlString = URLCnst.createAccntURL
        accountCreationController.navBarTitle = "Create an Account"
        self.navigationController!.pushViewController(accountCreationController, animated: true)
    }
    
    func showPendingLoginTask(){
        UIView.animate(withDuration: 0.8, animations: ({
            self.udacityLogin.alpha = 0
            self.OTMLogo.alpha = 1
            if let visualEffect = self.visualEffect{visualEffect.effect = nil}
        })){ successfulCompletion in
            self.udacityLogin.removeFromSuperview()
            self.redSpinner.startAnimating()
            self.loginAnimationSetUpCompleted()
        }
    }
}
