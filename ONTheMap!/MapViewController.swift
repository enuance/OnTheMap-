//
//  MapViewController.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/12/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{

    
    
    override func viewDidLoad() { super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
    }

    
    override func viewDidAppear(_ animated: Bool) {super.viewDidAppear(true)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    
}
