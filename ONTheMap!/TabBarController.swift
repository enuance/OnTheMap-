//
//  TabBarController.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/17/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {super.viewDidLoad();setUpNavBar()}

    func logOut(){
        guard let MVController = viewControllers?[0] as? MapViewController,
            let _ = viewControllers?[1] as? TableViewController else{
                SendError.toDisplay(self, errorType: GeneralError.UIConnection.rawValue, errorMessage: GeneralError.UIConnection.description, assignment: nil)
                return}
        MVController.animateLogout()
    }
    
    func refresh(){
        guard let MVController = viewControllers?[0] as? MapViewController,
        let _ = viewControllers?[1] as? TableViewController else{
            SendError.toDisplay(self, errorType: GeneralError.UIConnection.rawValue, errorMessage: GeneralError.UIConnection.description, assignment: nil)
            return}
        MVController.animateReload()
    }
    
    func addPin(){/* Add Code For Pin Adding MVC */}
    
}
