//
//  NavBarManagement.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/12/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import Foundation
import UIKit

extension WebViewController{
    func setUpNavBar(){
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = navBarTitle
        let back = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(navigateBack))
        navigationItem.leftBarButtonItem = back
        let navBarStyle: [String: Any] = [
            NSForegroundColorAttributeName: UIColor.red,
            NSFontAttributeName: UIFont(name: "Avenir Next Medium", size: CGFloat(16))!
        ]
        navigationController?.navigationBar.titleTextAttributes = navBarStyle
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(navBarStyle, for: .normal)
        navigationController?.navigationBar.tintColor = UIColor.red
    }
}


extension TabBarController{
    func setUpNavBar(){
        navigationController?.navigationBar.isHidden = false
        
        let logOut = UIBarButtonItem(image: UIImage(named: "Logout"), style: .plain, target: self, action: #selector(self.logOut))
        let refresh = UIBarButtonItem(image: UIImage(named: "Refresh"), style: .plain, target: self, action: #selector(self.refresh))
        let addPin = UIBarButtonItem(image: UIImage(named: "addPin"), style: .plain, target: self, action: #selector(self.addPin))
    
        navigationItem.title = "ON The Map!"
        navigationItem.leftBarButtonItem = logOut
        navigationItem.rightBarButtonItems = [refresh, addPin]
        
        let navBarStyle: [String: Any] = [
            NSForegroundColorAttributeName: UIColor.red,
            NSFontAttributeName: UIFont(name: "Avenir Next Medium", size: CGFloat(16))!
        ]
        navigationController?.navigationBar.titleTextAttributes = navBarStyle
        navigationController?.navigationBar.tintColor = UIColor.red
    }
}

