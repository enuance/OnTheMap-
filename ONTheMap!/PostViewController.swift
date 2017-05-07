//
//  PostViewController.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/27/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit
import MapKit

class PostViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var postButton: UIButton!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var locatingMap: MKMapView!
    @IBOutlet weak var linkAndPostView: UIView!
    @IBOutlet weak var entryView: UIView!
    
    var userToUpdate: Student!
    var mediaLinkToShare: String!
    let redSpinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    private weak var animationTimer: Timer?
    
    var MyTabBarController: TabBarController!{
        get{if let TBController = navigationController?.viewControllers[1] as? TabBarController{return TBController}else{return nil}}
    }
    
    var locationToView: MKAnnotation!{
        get{
            let mapPoint = MKPointAnnotation()
            if let userToUpdate = userToUpdate{
                let lat: CLLocationDegrees = Double(userToUpdate.latitude)
                let lon: CLLocationDegrees = Double(userToUpdate.longitude)
                mapPoint.coordinate = CLLocationCoordinate2DMake(lat, lon)
                mapPoint.title = "\(userToUpdate.firstName!) \(userToUpdate.lastName!)"
                return mapPoint
            }else{
                let lat: CLLocationDegrees = Double(OnTheMap.shared.user.latitude)
                let lon: CLLocationDegrees = Double(OnTheMap.shared.user.longitude)
                mapPoint.coordinate = CLLocationCoordinate2DMake(lat, lon)
                mapPoint.title = "\(OnTheMap.shared.user.firstName!) \(OnTheMap.shared.user.lastName!)"
                return mapPoint
            }
        }
    }
    
    override func viewDidLoad() {super.viewDidLoad()
        linkTextField.delegate = self
        locatingMap.layer.cornerRadius = 12
        locatingMap.addAnnotation(locationToView)
        setUpNavBar()
        subscribeToKeyboardNotifications()
    }

    override func viewDidAppear(_ animated: Bool) {super.viewDidAppear(animated); zoomInOnLocation()}
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "YouPin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {pinView = AnnotationView(annotation: annotation, reuseIdentifier: reuseId)}
        else {pinView?.annotation = annotation}
        pinView?.image = UIImage(named: "YouPin")
        pinView?.centerOffset.y = -22
        pinView?.canShowCallout = true
        return pinView
    }
    
    func zoomInOnLocation(_ spanDist: Double = 0.5, timeInt: Double = 0.5){
        animationTimer = Timer.scheduledTimer(withTimeInterval: timeInt, repeats: false){ timerHandle in
            let span = MKCoordinateSpanMake(spanDist, spanDist)
            let region = MKCoordinateRegionMake(self.locationToView.coordinate, span)
            self.locatingMap.setRegion(region, animated: true)
            switch spanDist{
            case 0.5: self.zoomInOnLocation(0.2, timeInt: 1.5)
            case 0.2: self.zoomInOnLocation(0.0015, timeInt: 2)
            default: break
            }
        }
    }
    
    func cancel(){
        if let MyTabBarController = MyTabBarController{
            MyTabBarController.userToPassToNextVC = nil
            OnTheMap.clearUserPostingInfo()
            navigationController?.popToViewController(MyTabBarController, animated: true)
        }
    }
    
    @IBAction func postIt(_ sender: UIButton) {
        guard let mediaLink = mediaLinkToShare else {return}
        navigationButtons(enabled: false)
        postButton.isEnabled = false
        redSpinner.startAnimating()
        if let _ = userToUpdate{
            userToUpdate.setPropertyBy(StudentCnst.mediaURL, with: mediaLink)
            ParseClient.updateUserLocation(user: userToUpdate){updated, error in
                DispatchQueue.main.async {
                    guard (error == nil) else{
                        self.redSpinner.stopAnimating()
                        SendToDisplay.error(self, errorType: String(describing: error!), errorMessage: error!.localizedDescription, assignment: ({self.navigationButtons(enabled: true); self.postButton.isEnabled = true}))
                        return}
                    guard let updated = updated, (updated == true) else{
                        self.redSpinner.stopAnimating()
                        SendToDisplay.error(self, errorType: "Server Did Not Update Location", errorMessage: "A time stamp for update was not retrieved", assignment: ({self.navigationButtons(enabled: true); self.postButton.isEnabled = true}))
                        return}
                    self.goToMapWithLocation(location: self.locationToView.coordinate)
                }
            }
        }else{
            OnTheMap.shared.user.setPropertyBy(StudentCnst.mediaURL, with: mediaLink)
            ParseClient.postUserLocation(user: OnTheMap.shared.user){objectID, error in
                DispatchQueue.main.async {
                    guard (error == nil) else{
                        self.redSpinner.stopAnimating()
                        SendToDisplay.error(self, errorType: String(describing: error!), errorMessage: error!.localizedDescription, assignment: ({self.navigationButtons(enabled: true); self.postButton.isEnabled = true}))
                        return}
                    guard let assignedObjectID = objectID else{
                        self.redSpinner.stopAnimating()
                        SendToDisplay.error(self, errorType: "Server Did Not Post Location", errorMessage: "An Object ID for posting was not retrieved", assignment: ({self.navigationButtons(enabled: true); self.postButton.isEnabled = true}))
                        return}
                    OnTheMap.shared.user.setPropertyBy(StudentCnst.objectId, with: assignedObjectID)
                    self.goToMapWithLocation(location: self.locationToView.coordinate)
                }
            }
        }
    }
    
    func goToMapWithLocation(location: CLLocationCoordinate2D){
        guard let MyTabBarVC = MyTabBarController, let MyMapVC = MyTabBarVC.MapController, let MyNavigator = navigationController else{
            SendToDisplay.error(self, errorType: GeneralError.UIConnection.rawValue, errorMessage: GeneralError.UIConnection.description, assignment: ({self.navigationButtons(enabled: true); self.postButton.isEnabled = true}))
            return
        }
        OnTheMap.clearUserPostingInfo()
        MyTabBarVC.userToPassToNextVC = nil
        MyMapVC.locationToView = location
        MyTabBarVC.selectedViewController = MyMapVC
        MyMapVC.animateReload(andZoomIn: true)
        MyNavigator.popToViewController(MyTabBarVC, animated: true)
    }
}
