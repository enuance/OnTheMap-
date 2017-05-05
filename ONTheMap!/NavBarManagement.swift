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
        navigationItem.title = "Create an Account"
        redSpinner.color = OTMColor().red
        redSpinner.hidesWhenStopped = true
        let navBarSpinner = UIBarButtonItem(customView: redSpinner)
        let back = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(navigateBack))
        navigationItem.leftBarButtonItem = back
        navigationItem.rightBarButtonItem = navBarSpinner
        let navBarStyle: [String: Any] = [
            NSForegroundColorAttributeName: OTMColor().white,
            NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: CGFloat(16))!
        ]
        let barButtonStyle: [String: Any] = [
            NSForegroundColorAttributeName: OTMColor().teal,
            NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: CGFloat(16))!
        ]
        navigationController?.navigationBar.titleTextAttributes = navBarStyle
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(barButtonStyle, for: .normal)
        navigationController?.navigationBar.tintColor = OTMColor().teal
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
            NSForegroundColorAttributeName: OTMColor().white,
            NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: CGFloat(16))!
        ]
        navigationController?.navigationBar.titleTextAttributes = navBarStyle
        navigationController?.navigationBar.tintColor = OTMColor().lightTeal
    }
    
    func navigationButtons(enabled: Bool){
        switch enabled{
        case true:
        navigationItem.leftBarButtonItem?.isEnabled = true
        navigationItem.rightBarButtonItems?[0].isEnabled = true
        navigationItem.rightBarButtonItems?[1].isEnabled = true
        case false:
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItems?[0].isEnabled = false
        navigationItem.rightBarButtonItems?[1].isEnabled = false
        }
    }
    
}

extension LocationViewController{
    func setUpNavBar(){
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .blackTranslucent
        
        redSpinner.color = OTMColor().red
        redSpinner.hidesWhenStopped = true
        
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancel))
        let navBarSpinner = UIBarButtonItem(customView: redSpinner)
        
        navigationItem.title = "Locate ON The Map!"
        navigationItem.leftBarButtonItem = cancel
        navigationItem.rightBarButtonItem = navBarSpinner
        
        let navBarStyle: [String: Any] = [
            NSForegroundColorAttributeName: OTMColor().white,
            NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: CGFloat(16))!
        ]
        
        let barButtonStyle: [String: Any] = [
            NSForegroundColorAttributeName: OTMColor().teal,
            NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: CGFloat(16))!
        ]
        
        navigationController?.navigationBar.titleTextAttributes = navBarStyle
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(barButtonStyle, for: .normal)
        navigationController?.navigationBar.tintColor = OTMColor().teal
    }
    
}

extension PostViewController{
    func setUpNavBar(){
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .blackTranslucent
        
        redSpinner.color = OTMColor().red
        redSpinner.hidesWhenStopped = true
        
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancel))
        let navBarSpinner = UIBarButtonItem(customView: redSpinner)
        
        navigationItem.title = "Pin it ON The Map!"
        navigationItem.leftBarButtonItem = cancel
        navigationItem.rightBarButtonItem = navBarSpinner
        
        let navBarStyle: [String: Any] = [
            NSForegroundColorAttributeName: OTMColor().white,
            NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: CGFloat(16))!
        ]
        
        let barButtonStyle: [String: Any] = [
            NSForegroundColorAttributeName: OTMColor().teal,
            NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: CGFloat(16))!
        ]
        
        navigationController?.navigationBar.titleTextAttributes = navBarStyle
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(barButtonStyle, for: .normal)
        navigationController?.navigationBar.tintColor = OTMColor().teal
    }
    
    func navigationButtons(enabled: Bool){
        switch enabled{
        case true: navigationItem.leftBarButtonItem?.isEnabled = true ; print("nav Item is \(String(describing: self.navigationItem.leftBarButtonItem?.isEnabled))")
        case false: navigationItem.leftBarButtonItem?.isEnabled = false; print("nav Item is \(String(describing: self.navigationItem.leftBarButtonItem?.isEnabled))")
        }
    }
    
}
