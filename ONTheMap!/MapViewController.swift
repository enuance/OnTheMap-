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
    @IBOutlet weak var redSpinner: UIActivityIndicatorView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    var selectedURL: String!
    
    override func viewDidLoad() {super.viewDidLoad()
        blurEffect.alpha = 0; blurEffect.effect = nil
        studentMap.addAnnotations(OnTheMap.shared.pins)
        connectSisterVCOutlets()
    }

    override func viewDidAppear(_ animated: Bool) {super.viewDidAppear(true)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "studentPin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {pinView = AnnotationView(annotation: annotation, reuseIdentifier: reuseId)}
        else {pinView?.annotation = annotation}
        
        //Returns a general student pin or a "You" pin based on a Unique Identifier/key
        if let studentPinAnnotation = pinView?.annotation as? StudentAnnotation, let theUniqueIdentifier = studentPinAnnotation.uniqueIdentifier, let yourUniqueIdentifier = OnTheMap.shared.user.uniqueKey, theUniqueIdentifier == yourUniqueIdentifier{
            pinView?.image = UIImage(named: "YouPin")
            return pinView
        }else{
            pinView?.image = UIImage(named:"studentPin")
            pinView?.centerOffset.y = -22
            return pinView
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let studentCalloutView = Bundle.main.loadNibNamed("StudentCallout", owner: self, options: nil)?.first as? StudentCallout else{return}
        guard let fullName = view.annotation?.title, let confirmedFullName = fullName else {return}
        guard let mediaURL = view.annotation?.subtitle, let confirmedMediaURL = mediaURL else {return}
        
        //Store the URL in Class Property for accessability to other methods.
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
    
    func loadMediaURLWithSafari(){
        let app = UIApplication.shared
        if let selectURL = selectedURL {
            if let verifiedURL = URL(string: selectURL.prefixHTTP){
                app.open(verifiedURL, options: [:], completionHandler: nil)
            }else{
                SendToDisplay.error(self,
                                    errorType: GeneralError.invalidURL.rawValue,
                                    errorMessage: GeneralError.invalidURL.description,
                                    assignment: nil)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        //Remove added Button
        view.subviews.first?.removeFromSuperview()
        //Remove Custom Callout
        view.subviews.first?.removeFromSuperview()
    }
    
    //The TableVC needs to be ready to go as soon as MapVC is ready.
    func connectSisterVCOutlets(){
        guard let TVController = self.tabBarController?.viewControllers?[1] as? TableViewController else {return}
        //Forcibly connect the outlets if not already connected (connects when it appears) by sending the view signal to the Controller
        _ = TVController.view
    }
    
    
}
