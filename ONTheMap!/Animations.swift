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
            //Disable the nav buttons so the methods are not called multiple times.
            self.tabBarController?.navigationItem.leftBarButtonItem?.isEnabled = false
            self.tabBarController?.navigationItem.rightBarButtonItems?[0].isEnabled = false
            self.tabBarController?.navigationItem.rightBarButtonItems?[1].isEnabled = false
            //Clear out annotations from UI
            self.studentMap.removeAnnotations(self.studentMap.annotations)
            //Clear out existing Locations/Pins from model.
            OnTheMap.clearLocationsAndPins()
            
            ParseClient.populateLocations(){ locationsCount, error in
                DispatchQueue.main.async {
                    guard (error == nil) else{
                        self.redSpinner.stopAnimating()
                        TVController.redSpinner.stopAnimating()
                        SendToDisplay.error(self.tabBarController!, errorType: "Network Error", errorMessage: error!.localizedDescription, assignment: ({
                            //Enable the nav buttons so the methods are accesible again.
                            self.tabBarController?.navigationItem.leftBarButtonItem?.isEnabled = true
                            self.tabBarController?.navigationItem.rightBarButtonItems?[0].isEnabled = true
                            self.tabBarController?.navigationItem.rightBarButtonItems?[1].isEnabled = true
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
                    //Enable the nav buttons so the methods are accesible again.
                    self.tabBarController?.navigationItem.leftBarButtonItem?.isEnabled = true
                    self.tabBarController?.navigationItem.rightBarButtonItems?[0].isEnabled = true
                    self.tabBarController?.navigationItem.rightBarButtonItems?[1].isEnabled = true
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
            //Disable the nav buttons so the methods are not called multiple times.
            self.tabBarController?.navigationItem.leftBarButtonItem?.isEnabled = false
            self.tabBarController?.navigationItem.rightBarButtonItems?[0].isEnabled = false
            self.tabBarController?.navigationItem.rightBarButtonItems?[1].isEnabled = false
            //Clear out existing Locations/Pins from model.
            OnTheMap.clearLocationsAndPins()
            
            udaClient.logout(){success, logoutID, error in
                DispatchQueue.main.async {
                    guard error == nil else{
                        self.redSpinner.stopAnimating()
                        TVController.redSpinner.stopAnimating()
                        SendToDisplay.error(self.tabBarController!, errorType: "Network Error", errorMessage: error!.localizedDescription, assignment: ({
                            //Enable the nav buttons so the methods are accesible again.
                            self.tabBarController?.navigationItem.leftBarButtonItem?.isEnabled = true
                            self.tabBarController?.navigationItem.rightBarButtonItems?[0].isEnabled = true
                            self.tabBarController?.navigationItem.rightBarButtonItems?[1].isEnabled = true
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
        guard (isReloadingOrLogout ?? false) == false else{return}
        coordinator.animate(alongsideTransition: ({_ in
            let newRatio = (self.studentTable.contentOffset.y/self.studentTable.contentSize.height)
            let newDistanceToMove = (self.backGroundImage.frame.height - size.height) * newRatio
            self.backGroundImage.transform = CGAffineTransform(translationX: 0, y: -newDistanceToMove)
        }))
    }
    
}

extension TabBarController{
    
    func animateRedSpinners(_ on: Bool){
        guard let MapController = self.viewControllers?[0] as? MapViewController else{return}
        guard let TableController = self.viewControllers?[1] as? TableViewController else{return}
        switch on{
        case true: MapController.redSpinner.startAnimating(); TableController.redSpinner.startAnimating()
        case false: MapController.redSpinner.stopAnimating(); TableController.redSpinner.stopAnimating()
        }
    }
    
    func animateStartActivity(completionHandler: (()-> Void)?){
        guard let MapController = self.viewControllers?[0] as? MapViewController else{return}
        guard let TableController = self.viewControllers?[1] as? TableViewController else{return}
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItems?[0].isEnabled = false
        navigationItem.rightBarButtonItems?[1].isEnabled = false
        let animateIn: TimeInterval = 0.5
        UIView.animate(withDuration: animateIn, animations: ({
            MapController.blurEffect.alpha = 1 ; MapController.blurEffect.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
            TableController.blurEffect.alpha = 1; TableController.blurEffect.effect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        })){
            animationEnded in
            self.animateRedSpinners(true)
            if let handler = completionHandler{handler()}
        }
    }
    
    func animateEndActivity(completionHandler: (()-> Void)?){
        guard let MapController = self.viewControllers?[0] as? MapViewController else{return}
        guard let TableController = self.viewControllers?[1] as? TableViewController else{return}
        animateRedSpinners(false)
        if let handler = completionHandler{handler()}
        let animateIn: TimeInterval = 0.5
        UIView.animate(withDuration: animateIn, animations: ({
            MapController.blurEffect.alpha = 0 ; MapController.blurEffect.effect = nil
            TableController.blurEffect.alpha = 0; TableController.blurEffect.effect = nil
        })){
            animationEnded in
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.navigationItem.rightBarButtonItems?[0].isEnabled = true
            self.navigationItem.rightBarButtonItems?[1].isEnabled = true

        }
    }
    

    
    func animateCheckForExisting(){
        animateStartActivity(){
            ParseClient.checkExistingUserLocation(user: OnTheMap.shared.user){ isExisting, theExistingUser, error in
                DispatchQueue.main.async {
                    guard (error == nil) else{
                        self.animateRedSpinners(false)
                        SendToDisplay.error(self, errorType: "Network Error", errorMessage: error!.localizedDescription,
                                            assignment: ({self.animateEndActivity(completionHandler: nil)}))
                        return
                    }
                    guard let isExisting = isExisting else{self.animateEndActivity(completionHandler: nil);return}
                    //If No User is found then segue to create a new location
                    if !isExisting{self.animateEndActivity(){self.performSegue(withIdentifier: "showLocationViewController", sender: self)}}
                    //Otherwise Question the App User for a response
                    else{ guard let foundUser = theExistingUser else{self.animateEndActivity(completionHandler: nil);return}
                        let actions: [String : () -> (Void)] = [
                            "Add": ({
                                self.animateEndActivity(){
                                    self.performSegue(withIdentifier: "showLocationViewController", sender: self)
                                }
                            }),
                            "Overwrite":({
                                self.animateEndActivity(){
                                    self.userToPassToNextVC = foundUser
                                    self.performSegue(withIdentifier: "showLocationViewController", sender: self)
                                }
                            }),
                            "Delete":({
                                self.animateRedSpinners(true)
                                ParseClient.deleteUserLocation(user: foundUser){deletionCompleted, error in
                                    DispatchQueue.main.async {
                                        guard (error == nil) else{
                                            self.animateRedSpinners(false)
                                            SendToDisplay.error(self, errorType: "Network Error", errorMessage: error!.localizedDescription,
                                                                assignment: ({self.animateEndActivity(completionHandler: nil)}))
                                            return
                                        }
//..................................................................................................................................
//                              Might be helpful to automate the reload from here!!!!
//..................................................................................................................................
                                        self.animateEndActivity(completionHandler: nil)
                                    }
                                }
                            })
                        ]
                        self.animateRedSpinners(false)
                        SendToDisplay.question(self,
                                               QTitle: "Existing User Location",
                                               QMessage: "You have an existing user location already OnTheMap! What would you like to do with it?",
                                               assignments: actions)
                    }
                }
            }
        }
    }
    
    
    
    
}



