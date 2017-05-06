//
//  Animations.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/10/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//
/*
 This file contains all the animation related methods for the app and extends many of the View Controllers throughout the app. Many of the client methods
 are closely intertwined with the animations throughout the app and thus the implementations of some of those methods can be found here.
 */

import UIKit
import MapKit

//........................................................................................................
//                              Animations For The Login Controller
//........................................................................................................
extension OTMLoginController{
    func animateHomeScreen(){
        UIView.animate(withDuration: 0.7, animations: ({
            self.OTMLogo.alpha = 1
            self.loginTray.transform = CGAffineTransform(translationX: 0, y: -(self.loginButton.frame.height * 1.25))
            self.loginButton.transform = CGAffineTransform(rotationAngle: ConvertObject.toRadians(180))
        })){ successfulCompletion in
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
        UIView.animate(withDuration: 0.7){
            if let visualEffect = self.visualEffect{visualEffect.effect = UIBlurEffect(style: UIBlurEffectStyle.light)}
            self.udacityLogin.alpha = 1
            self.OTMLogo.alpha = 0
            self.loginTray.transform = CGAffineTransform.identity
            self.loginButton.transform = CGAffineTransform.identity
            self.OTMPin.transform = CGAffineTransform.identity
        }
    }
    
    func animateRemovingLoginView(){
        UIView.animate(withDuration: 0.7, animations: ({
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
        navigationController!.pushViewController(accountCreationController, animated: true)
    }
    
    func showPendingLoginTask(){
        UIView.animate(withDuration: 0.7, animations: ({
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

//........................................................................................................
//                              Animations For The Tab Bar Controller
//........................................................................................................
extension TabBarController{
    func animateRedSpinners(_ on: Bool){
        switch on{
        case true: MapController.redSpinner.startAnimating(); TableController.redSpinner.startAnimating()
        case false: MapController.redSpinner.stopAnimating(); TableController.redSpinner.stopAnimating()
        }
    }
    
    func animateStartActivity(completionHandler: (()-> Void)?){
        self.navigationButtons(enabled: false)
        let animateIn: TimeInterval = 0.5
        UIView.animate(withDuration: animateIn, animations: ({
            self.MapController.blurEffect.alpha = 1 ; self.MapController.blurEffect.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
            self.TableController.blurEffect.alpha = 1; self.TableController.blurEffect.effect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        })){
            animationEnded in
            self.animateRedSpinners(true)
            if let handler = completionHandler{handler()}
        }
    }
    
    func animateEndActivity(completionHandler: (()-> Void)?){
        animateRedSpinners(false)
        if let handler = completionHandler{handler()}
        let animateIn: TimeInterval = 0.5
        UIView.animate(withDuration: animateIn, animations: ({
            self.MapController.blurEffect.alpha = 0 ; self.MapController.blurEffect.effect = nil
            self.TableController.blurEffect.alpha = 0; self.TableController.blurEffect.effect = nil
        })){
            animationEnded in self.navigationButtons(enabled: true)
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
                            "Add New Location": ({
                                self.animateEndActivity(){
                                    self.performSegue(withIdentifier: "showLocationViewController", sender: self)
                                }
                            }),
                            "Update Location":({
                                self.animateEndActivity(){
                                    self.userToPassToNextVC = foundUser
                                    self.performSegue(withIdentifier: "showLocationViewController", sender: self)
                                }
                            }),
                            "Delete Location":({
                                self.animateRedSpinners(true)
                                ParseClient.deleteUserLocation(user: foundUser){deletionCompleted, error in
                                    DispatchQueue.main.async {
                                        guard (error == nil) else{
                                            self.animateRedSpinners(false)
                                            SendToDisplay.error(self, errorType: "Network Error", errorMessage: error!.localizedDescription,
                                                                assignment: ({self.animateEndActivity(completionHandler: nil)}))
                                            return
                                        }
                                        //Refresh the Map & Table.
                                        self.MapController.animateReload()
                                    }
                                }
                            })
                        ]
                        self.animateRedSpinners(false)
                        SendToDisplay.question(self,
                                               QTitle: "Existing User Location",
                                               QMessage: "You have an existing user location already OnTheMap! What would you like to do?",
                                               assignments: actions)
                    }
                }
            }
        }
    }
}

//........................................................................................................
//                      Animations For The MapView Controller (Embedding in Tab Bar Controller)
//........................................................................................................
extension MapViewController{
    func animateReload(andZoomIn: Bool = false){
        //Handle for the Tab Bar Controller and other view in the Tab Bar Controller
        guard let TVController = self.tabBarController?.viewControllers?[1] as? TableViewController else {return}
        guard let TabController = self.tabBarController as? TabBarController else {return}
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
            TabController.navigationButtons(enabled: false)
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
                            TabController.navigationButtons(enabled: true)
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
                    TabController.navigationButtons(enabled: true)
                    UIView.animate(withDuration: animateOut, animations: ({
                        self.blurEffect.alpha = 0
                        TVController.blurEffect.alpha = 0
                        self.blurEffect.effect = nil
                        TVController.blurEffect.effect = nil
                    }), completion: ({successfullCompletion in if andZoomIn{ self.zoomInOnLocation()}}))
                }
            }
        }))
    }
    
    func animateLogout(){
        //Handle for the Tab Bar Controller and the other view in the Tab Bar Controller
        guard let TVController = self.tabBarController?.viewControllers?[1] as? TableViewController else {return}
        guard let TabController = self.tabBarController as? TabBarController else {return}
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
            TabController.navigationButtons(enabled: false)
            //Clear out existing Locations/Pins from model.
            OnTheMap.clearLocationsAndPins()
            udaClient.logout(){success, logoutID, error in
                DispatchQueue.main.async {
                    guard error == nil else{
                        self.redSpinner.stopAnimating()
                        TVController.redSpinner.stopAnimating()
                        SendToDisplay.error(self.tabBarController!, errorType: "Network Error", errorMessage: error!.localizedDescription, assignment: ({
                            //Enable the nav buttons so the methods are accesible again.
                            TabController.navigationButtons(enabled: true)
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

//........................................................................................................
//                      Animations For The TableView Controller (Embedding in Tab Bar Controller)
//........................................................................................................
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

//........................................................................................................
//                      Animations For The Student Cell (Embedding in TableView Controller)
//........................................................................................................
extension StudentCell{
    func animateSelection(completionHandler: @escaping () -> Void){
        UIView.animate(withDuration: 0.2, animations: ({
            self.blurEffect.effect = UIBlurEffect(style: .light)
            self.OpaqueBG.alpha = 0.4
        })){successful in
            UIView.animate(withDuration: 0.1, animations: ({
                self.blurEffect.effect = nil
                self.OpaqueBG.alpha = 0
            })){successful in
                return completionHandler()
            }
        }
    }
}

//........................................................................................................
//                              Animations For The Location View Controller
//........................................................................................................
extension LocationViewController{
    func animateLocateButton(){
        locateButton.translatesAutoresizingMaskIntoConstraints = true
        view.addSubview(locateButton)
        locateButton.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        locateButton.autoresizingMask = [
            UIViewAutoresizing.flexibleLeftMargin,
            UIViewAutoresizing.flexibleRightMargin,
            UIViewAutoresizing.flexibleTopMargin,
            UIViewAutoresizing.flexibleBottomMargin]
        UIView.animate(withDuration: 0.5, animations: ({
            self.messageView.alpha = 0
        }), completion: ({completed in
            UIView.animate(withDuration: 0.5){
                self.locateButton.alpha = 1
                self.locateButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
        }))
    }
}

//........................................................................................................
//                              Animations For The Post View Controller
//........................................................................................................
extension PostViewController{
    func animatePostItButton(){
        UIView.animate(withDuration: 0.5, animations: ({
            self.entryView.alpha = 0
        }), completion: ({ completed in
            self.postButton.translatesAutoresizingMaskIntoConstraints = true
            self.linkAndPostView.addSubview(self.postButton)
            self.postButton.center = CGPoint(x: self.linkAndPostView.bounds.midX, y: self.linkAndPostView.bounds.midY)
            self.postButton.autoresizingMask = [
                UIViewAutoresizing.flexibleLeftMargin,
                UIViewAutoresizing.flexibleRightMargin,
                UIViewAutoresizing.flexibleTopMargin,
                UIViewAutoresizing.flexibleBottomMargin]
            UIView.animate(withDuration: 0.5, animations: ({
                self.postButton.alpha = 1
                self.postButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }))
        }))
    }
}


