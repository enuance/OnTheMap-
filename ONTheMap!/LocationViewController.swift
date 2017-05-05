//
//  LocationViewController.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/21/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController, UITextFieldDelegate {

    var userToUpdate: Student!
    let OTMLocator = CLGeocoder()
    let redSpinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    @IBOutlet var locateButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var messageView: UIView!
    
    var MyTabBarController: TabBarController!{
        get{if let TBController = navigationController?.viewControllers[1] as? TabBarController{return TBController}else{return nil}}
    }
    
    override func viewDidLoad() {super.viewDidLoad()
        setUpNavBar()
        subscribeToKeyboardNotifications()
        locationTextField.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let entry = textField.text ?? ""
        if entry.isBlank{
            textField.resignFirstResponder()
            SendToDisplay.error(self, errorType: "Text Field is Blank", errorMessage: "Please enter a location for us to search.", assignment: nil)
            return true
        }else{
            geoCodeEntry(entry: entry)
            textField.resignFirstResponder()
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {super.prepare(for: segue, sender: sender)
        if segue.identifier == "ShowPostViewController"{
            if let LocationVC = segue.destination as? PostViewController{
                LocationVC.userToUpdate = userToUpdate
            }
        }
    }
    
    func cancel(){
        if OTMLocator.isGeocoding{OTMLocator.cancelGeocode()}
        MyTabBarController?.userToPassToNextVC = nil
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func locate(_ sender: UIButton) {self.performSegue(withIdentifier: "ShowPostViewController", sender: self)}
    
    func geoCodeEntry(entry: String){
        let genericGeocodeError = "The Server was unable to locate your entry"
        self.redSpinner.startAnimating()
        OTMLocator.geocodeAddressString(entry){ placeMarkList, error in
            guard (error == nil) else{
                SendToDisplay.error(self, errorType: "Geocode Error",errorMessage: error?.localizedDescription ?? genericGeocodeError,assignment: ({self.redSpinner.stopAnimating()}))
                return}
            guard let placeMarkList = placeMarkList,
                let placeMark = placeMarkList.first,
                let latitude = placeMark.location?.coordinate.latitude,
                let longitude = placeMark.location?.coordinate.longitude  else {
                    SendToDisplay.error(self, errorType: "Geocode Error",errorMessage: error?.localizedDescription ?? genericGeocodeError,assignment: ({self.redSpinner.stopAnimating()}))
                    return}
            self.OTMLocator.reverseGeocodeLocation(placeMark.location!){ possibleLocationList, error in
                guard (error == nil) else{
                    SendToDisplay.error(self, errorType: "Geocode Error",errorMessage: error?.localizedDescription ?? genericGeocodeError,assignment: ({self.redSpinner.stopAnimating()}))
                    return}
                guard let possibleLocationList = possibleLocationList,
                    let locationInfo = possibleLocationList.first else{
                        SendToDisplay.error(self, errorType: "Geocode Error",errorMessage: error?.localizedDescription ?? genericGeocodeError,assignment: ({self.redSpinner.stopAnimating()}))
                        return}
                let address = (locationInfo.subThoroughfare != nil ? "\(locationInfo.subThoroughfare!) " : "") + (locationInfo.thoroughfare != nil ? "\(locationInfo.thoroughfare!), " : "")
                let cityState = (locationInfo.locality != nil ? "\(locationInfo.locality!) ":"") + (locationInfo.administrativeArea != nil ? "\(locationInfo.administrativeArea!)" : "")
                let locationString = address + cityState
                
                if let userToUpdate = self.userToUpdate{
                    let updateData: [String: Any] = [
                        StudentCnst.firstName : OnTheMap.shared.user.firstName,
                        StudentCnst.lastName : OnTheMap.shared.user.lastName,
                        StudentCnst.mapString : locationString,
                        StudentCnst.latitude : latitude,
                        StudentCnst.longitude : longitude
                    ]
                    for (key, value) in updateData{
                        userToUpdate.setPropertyBy(key, with: value)
                    }
                }else{
                    let updateData: [String:Any] = [
                        StudentCnst.mapString : locationString,
                        StudentCnst.latitude : latitude,
                        StudentCnst.longitude : longitude
                    ]
                    for (key, value) in updateData{
                        OnTheMap.shared.user.setPropertyBy(key, with: value)
                    }
                }
                self.redSpinner.stopAnimating()
                self.animateLocateButton()
            }
        }
    }
    
}
