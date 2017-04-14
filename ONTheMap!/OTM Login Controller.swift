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
    @IBOutlet weak var redSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var loginTray: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet var udacityLogin: UIView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    
    override func viewDidLoad() { super.viewDidLoad()
        if let visualEffect = visualEffect{visualEffect.effect = nil}
        userNameField.delegate = self
        passwordField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(true)
        UIApplication.shared.statusBarStyle = .default
        animateHomeScreen()
    }
    
    @IBAction func showUdacityLoginView(_ sender: UIButton) {animateLoginView()}
    @IBAction func removeUdacityLoginView(_ sender: UIButton) {animateRemovingLoginView()}
    @IBAction func createAccount(_ sender: UIButton) {animateAccountCreation()}

    func loginAnimationSetUpCompleted(){loginAndPopulateOTM()}
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if userNameField.text == nil || userNameField.text!.isBlank{userNameField.becomeFirstResponder() ;return false}
        if passwordField.text == nil || passwordField.text!.isBlank{passwordField.becomeFirstResponder() ;return false}
        OnTheMap.shared.userName = userNameField.text!; OnTheMap.shared.userPassword = passwordField.text!
        textField.resignFirstResponder()
        userNameField.text = ""; passwordField.text = ""
        showPendingLoginTask()
        return true
    }
    
    func loginAndPopulateOTM(){
        udaClient.authenticate(userName: (OnTheMap.shared.userName ?? ""), passWord: (OnTheMap.shared.userPassword ?? "")){ accountID, sessionID, error in
            OnTheMap.shared.userName = nil ; OnTheMap.shared.userPassword = nil
            DispatchQueue.main.async {
                guard (error == nil)else {
                    self.redSpinner.stopAnimating()
                    SendError.toDisplay(self, errorType: String(describing: error!), errorMessage: error!.localizedDescription, assignment: ({self.animateHomeScreen()}))
                    return}
                guard let accountID = accountID, let sessionID = sessionID else{
                    self.redSpinner.stopAnimating()
                    SendError.toDisplay(self,errorType: "Network Error", errorMessage: "Unable to retrieve needed data from Udacity",assignment: ({self.animateHomeScreen()}))
                    return}
                print("Successful Login Attempt! The session ID is \(sessionID)")
                OnTheMap.shared.user.setPropertyBy(StudentCnst.uniqueKey, with: accountID)
                
                //Start populating the students location and pins list.
                ParseClient.populateLocations(){ locationsCount, error in
                    DispatchQueue.main.async {
                        guard (error == nil) else{
                            self.redSpinner.stopAnimating()
                            SendError.toDisplay(self, errorType: "Network Error", errorMessage: error!.localizedDescription, assignment: ({self.animateHomeScreen()}))
                            return
                            }
                        OnTheMap.pinTheLocations()
                        self.redSpinner.stopAnimating()
                        //No prepare needed. Using shared data from singleton
                        self.performSegue(withIdentifier: "showTabBarController", sender: self)
                    }
                }
                //Allow the udaClient to get user info in the background.
                udaClient.getPublicUserInfo(userAcctID: accountID){ firstName, lastName, error in
                    guard (error == nil)else {DispatchQueue.main.async {
                        //May not be on the login VC by the time this is called / need to access the top VC!
                        SendError.toDisplay((self.navigationController?.topViewController)!, errorType: String(describing: error!),errorMessage: "Unable to retrieve User info due to Netwrok Error. Description: \(error!.localizedDescription)",assignment: ({self.navigationController?.popToRootViewController(animated: true)}))
                        }//End MainQueue work | Begin background work:
                        return}
                    guard let firstName = firstName, let lastName = lastName else{DispatchQueue.main.async {
                            SendError.toDisplay((self.navigationController?.topViewController)!, errorType: "Unable to retrieve User info", errorMessage: "The User's first name or last name is not set!", assignment: ({self.navigationController?.popToRootViewController(animated: true)}))
                        }//End MainQueue work | Begin background work:
                        return}
                    OnTheMap.shared.user.setPropertyBy(StudentCnst.firstName, with: firstName)
                    OnTheMap.shared.user.setPropertyBy(StudentCnst.lastName, with: lastName)
                }//End Background work
            }
        }
    }
}


