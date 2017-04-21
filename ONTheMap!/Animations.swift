//
//  Animations.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/10/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import Foundation
import UIKit
import MapKit

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

extension MapViewController{
    
    func animateReload(){
        //Handle for the other view in the Tab Bar Controller
        guard let TVController = self.tabBarController?.viewControllers?[1] as? TableViewController else {return}
        //Forcibly connect the outlets if not already connected (connects when it appears) by sending the view signal to the Controller
        _ = TVController.view
        let animateIn: TimeInterval = 0.5
        let animateOut: TimeInterval = 0.5
        
        UIView.animate(withDuration: animateIn, animations: ({
            self.blurEffect.alpha = 1
            TVController.blurEffect.alpha = 1
            self.blurEffect.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
            TVController.blurEffect.effect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        }), completion: ({successfullCompletion in
            
            //Start spinner to indicate activity
            self.redSpinner.startAnimating()
            TVController.redSpinner.startAnimating()
            TVController.isReloadingOrLogout = true
            //Clear out annotations from UI
            self.studentMap.removeAnnotations(self.studentMap.annotations)
            //Clear out existing Locations/Pins from model.
            OnTheMap.clearLocationsAndPins()
            
            ParseClient.populateLocations(){ locationsCount, error in
                DispatchQueue.main.async {
                    guard (error == nil) else{
                        self.redSpinner.stopAnimating()
                        TVController.redSpinner.stopAnimating()

                        SendError.toDisplay(self.tabBarController!, errorType: "Network Error", errorMessage: error!.localizedDescription, assignment: ({
                            UIView.animate(withDuration: animateOut, animations: ({
                                self.blurEffect.alpha = 0
                                TVController.blurEffect.alpha = 0
                                self.blurEffect.effect = nil
                                TVController.blurEffect.effect = nil
                            }))
                            TVController.isReloadingOrLogout = false
                        }))
                        return
                    }
                    //repin the locations
                    OnTheMap.pinTheLocations()
                    //Repopulate the UI for Map
                    self.studentMap.addAnnotations(OnTheMap.shared.pins)
                    //Repopulate the UI for Table
                    TVController.studentTable.reloadData()
                    self.redSpinner.stopAnimating()
                    TVController.redSpinner.stopAnimating()
                    TVController.isReloadingOrLogout = false
                    UIView.animate(withDuration: animateOut, animations: ({
                        self.blurEffect.alpha = 0
                        TVController.blurEffect.alpha = 0
                        
                        self.blurEffect.effect = nil
                        TVController.blurEffect.effect = nil
                        
                    }))
                }
            }
        }))
    }
    
    func animateLogout(){
        //Handle for the other view in the Tab Bar Controller
        guard let TVController = self.tabBarController?.viewControllers?[1] as? TableViewController else {return}
        //Forcibly connect the outlets if not already connected (connects when it appears) by sending the view signal to the Controller
        _ = TVController.view
        let animateIn: TimeInterval = 0.5
        let animateOut: TimeInterval = 0.5
        
        UIView.animate(withDuration: animateIn, animations: ({
            self.blurEffect.alpha = 1
            TVController.blurEffect.alpha = 1
            self.blurEffect.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
            TVController.blurEffect.effect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        }), completion: ({successfullCompletion in
            
            //Start spinner to indicate activity
            self.redSpinner.startAnimating()
            TVController.redSpinner.startAnimating()
            TVController.isReloadingOrLogout = true
            //Disable the logoutButton so the method is not called multiple times.
            self.tabBarController?.navigationItem.leftBarButtonItem?.isEnabled = false
            //Clear out existing Locations/Pins from model.
            OnTheMap.clearLocationsAndPins()
            
            udaClient.logout(){success, logoutID, error in
                DispatchQueue.main.async {
                    guard error == nil else{
                        self.redSpinner.stopAnimating()
                        TVController.redSpinner.stopAnimating()
                        SendError.toDisplay(self.tabBarController!, errorType: "Network Error", errorMessage: error!.localizedDescription, assignment: ({
                            //Enable the logoutButton so the method is accesible again.
                            self.tabBarController?.navigationItem.leftBarButtonItem?.isEnabled = true
                            UIView.animate(withDuration: animateOut, animations: ({
                                self.blurEffect.alpha = 0
                                TVController.blurEffect.alpha = 0
                                self.blurEffect.effect = nil
                                TVController.blurEffect.effect = nil
                            }))
                            TVController.isReloadingOrLogout = false
                        }))
                        return
                    }
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }))
    }

}

extension TableViewController{
    
    //Controls The Background Scroll Effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tableHeight = scrollView.contentSize.height
        let distanceDown = scrollView.contentOffset.y
        distanceRatio = distanceDown/tableHeight
        let distanceToMoveImage = (backGroundImage.frame.height - view.bounds.height) * distanceRatio
        backGroundImage.transform = CGAffineTransform(translationX: 0, y: -distanceToMoveImage)
    }
    
    //Fixes the background scroll effect during frame transition (iOS device turned).
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: ({_ in
            let newRatio = (self.studentTable.contentOffset.y/self.studentTable.contentSize.height)
            let newDistanceToMove = (self.backGroundImage.frame.height - size.height) * newRatio
            self.backGroundImage.transform = CGAffineTransform(translationX: 0, y: -newDistanceToMove)
        }))
    }
    
}
