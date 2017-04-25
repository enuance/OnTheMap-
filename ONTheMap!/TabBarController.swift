//
//  TabBarController.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/17/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var userToPassToNextVC: Student!{
        willSet{
            print("The User to pass has been set:")
            if let user = newValue{
                print(user.description)
            }else{
                print("The User has been set to nil!!!!!")
            }
        }
    }
    
    override func viewDidLoad() {super.viewDidLoad();setUpNavBar()}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {super.prepare(for: segue, sender: sender)
        if segue.identifier == "showLocationViewController"{
            if let LocationVC = segue.destination as? LocationViewController{
                LocationVC.userToUpdate = userToPassToNextVC
            }
        }
    }
    
    func logOut(){
        guard let MVController = viewControllers?[0] as? MapViewController,
            let _ = viewControllers?[1] as? TableViewController else{
                SendToDisplay.error(self, errorType: GeneralError.UIConnection.rawValue, errorMessage: GeneralError.UIConnection.description, assignment: nil)
                return}
        MVController.animateLogout()
    }
    
    func refresh(){
        guard let MVController = viewControllers?[0] as? MapViewController,
        let _ = viewControllers?[1] as? TableViewController else{
            SendToDisplay.error(self, errorType: GeneralError.UIConnection.rawValue, errorMessage: GeneralError.UIConnection.description, assignment: nil)
            return}
        MVController.animateReload()
    }
    
    func addPin(){animateCheckForExisting()}
    
}
