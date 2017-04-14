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

    @IBOutlet weak var studentMap: MKMapView!
    
    override func viewDidLoad() {super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        //Set up Nav Bar Here!!!
        studentMap.addAnnotations(OnTheMap.shared.pins)
    }

    override func viewDidAppear(_ animated: Bool) {super.viewDidAppear(true)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    //Delegate Method for adding custom pin images
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            //pinView!.image = UIImage(named: "OTM")
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.calloutOffset = CGPoint(x: -5, y: 5)
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)}
        else {pinView!.annotation = annotation}
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let mediaURL = view.annotation?.subtitle! {
                app.open(URL(string: mediaURL.prefixHTTP)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    
}
