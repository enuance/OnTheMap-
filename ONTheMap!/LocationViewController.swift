//
//  LocationViewController.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/21/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    var userToUpdate: Student!
    
    override func viewDidLoad() {super.viewDidLoad()
        setUpNavBar()
        if let user = userToUpdate{
            print("The User Has been passed and is ready for use!")
            print(user.description)
        }
    }

    func cancel(){
        //Clear Out Possible User Info to pass
        if let TBController = navigationController?.viewControllers[1] as? TabBarController{
            TBController.userToPassToNextVC = nil
        }
        
        navigationController?.popViewController(animated: true)
    }
    

}
