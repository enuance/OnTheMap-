//
//  TabBarController.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/17/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var userToPassToNextVC: Student!
    
    var MapController: MapViewController!{
        get{guard let MVController = viewControllers?[0] as? MapViewController else{return nil};return MVController}
    }
    
    var TableController: TableViewController!{
        get{guard let TVController = viewControllers?[1] as? TableViewController else{return nil};return TVController}
    }
    
    override func viewDidLoad(){super.viewDidLoad();setUpNavBar()}
    
    override func viewWillAppear(_ animated: Bool) {super.viewWillAppear(animated);setUpNavBar()}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {super.prepare(for: segue, sender: sender)
        if segue.identifier == "showLocationViewController"{
            if let LocationVC = segue.destination as? LocationViewController{
                LocationVC.userToUpdate = userToPassToNextVC
            }
        }
    }
    
    func logOut(){ guard let MVController = MapController, let _ = TableController else{
        SendToDisplay.error(self, errorType: GeneralError.UIConnection.rawValue, errorMessage: GeneralError.UIConnection.description, assignment: nil)
        return}
        MVController.animateLogout()
    }
    
    func refresh(){ guard let MVController = MapController, let _ = TableController else{
        SendToDisplay.error(self, errorType: GeneralError.UIConnection.rawValue, errorMessage: GeneralError.UIConnection.description, assignment: nil)
        return}
        MVController.animateReload()
    }
    
    func addPin(){ guard let _ = MapController, let _ = TableController else{
        SendToDisplay.error(self, errorType: GeneralError.UIConnection.rawValue, errorMessage: GeneralError.UIConnection.description, assignment: nil)
        return}
        animateCheckForExisting()
    }
    
}
