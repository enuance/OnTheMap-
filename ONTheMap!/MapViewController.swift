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
    
    var selectedURL: String!
    
    override func viewDidLoad() {super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        //Set up Nav Bar Here!!!
        studentMap.addAnnotations(OnTheMap.shared.pins)
    }

    override func viewDidAppear(_ animated: Bool) {super.viewDidAppear(true)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {pinView = AnnotationView(annotation: annotation, reuseIdentifier: reuseId)}
        else {pinView?.annotation = annotation}
        pinView?.image = UIImage(named:"studentPin")
        pinView?.centerOffset.y = -22
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let studentCalloutView = Bundle.main.loadNibNamed("StudentCallout", owner: self, options: nil)?.first as? StudentCallout else{return}
        guard let fullName = view.annotation?.title, let confirmedFullName = fullName else {return}
        guard let mediaURL = view.annotation?.subtitle, let confirmedMediaURL = mediaURL else {return}
        
        selectedURL = confirmedMediaURL
        studentCalloutView.name.text = confirmedFullName
        studentCalloutView.mediaURL.text = confirmedMediaURL
        
        studentCalloutView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(studentCalloutView)
        
        NSLayoutConstraint.activate([
            studentCalloutView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            studentCalloutView.widthAnchor.constraint(equalToConstant: 210),
            studentCalloutView.heightAnchor.constraint(equalToConstant: 73),
            studentCalloutView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 73)
            ])
        
        let calloutButton = UIButton(type: .custom)
        calloutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calloutButton)
        
        NSLayoutConstraint.activate([
            calloutButton.topAnchor.constraint(equalTo: studentCalloutView.topAnchor),
            calloutButton.bottomAnchor.constraint(equalTo: studentCalloutView.bottomAnchor),
            calloutButton.leadingAnchor.constraint(equalTo: studentCalloutView.leadingAnchor),
            calloutButton.trailingAnchor.constraint(equalTo: studentCalloutView.trailingAnchor)
            ])
        
        calloutButton.addTarget(self, action: #selector(loadMediaURLWithSafari), for: .touchUpInside)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("pressed!!!")
    }
    
    func loadMediaURLWithSafari(){
        print("loadMediaURL was called!")
        let app = UIApplication.shared
        if let selectURL = selectedURL {
            app.open(URL(string: selectURL.prefixHTTP)!, options: [:], completionHandler: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.subviews.first?.removeFromSuperview()
        view.subviews.first?.removeFromSuperview()
    }
    
    
    
}
