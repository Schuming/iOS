//
//  FirstViewController.swift
//  MyLocations
//
//  Created by Lu Jingjing on 15/12/16.
//  Copyright © 2015年 Schuming. All rights reserved.
//

import UIKit
import CoreLocation

class CurrLocationViewController: UIViewController ,CLLocationManagerDelegate{
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLable: UILabel!
    
    @IBOutlet weak var longtitudeLable: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    var location: CLLocation?
    
    var updatingLocation = false
    var lastLocationError : NSError?
    
    let locationManger = CLLocationManager()
    
    @IBAction func getLocation(sender: AnyObject) {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .NotDetermined {
            locationManger.requestWhenInUseAuthorization()
            return
        }
        
        
        if authStatus == CLAuthorizationStatus.Denied || authStatus == CLAuthorizationStatus.Restricted {
            showLocationServicesDeniedAlert()
            return
        }

        if updatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            
            startLocationManager()
        }
        updateLabels()
        configureGetButton()
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        updateLabels()
        
        configureGetButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLocationServicesDeniedAlert(){
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alert.addAction(okAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: - CLLocationMangerDelegate
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWtihError \(error)")
        
        if error.code == CLError.LocationUnknown.rawValue {
            return
        }
        
        lastLocationError = error
        
        stopLocationManager()
        updateLabels()
        configureGetButton()
    }
    
    func startLocationManager(){
        if CLLocationManager.locationServicesEnabled() {
            locationManger.delegate = self
            locationManger.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManger.startUpdatingLocation()
            updatingLocation = true
        }
    }
    
    func stopLocationManager()
    {
        if updatingLocation {
            locationManger.stopUpdatingLocation()
            locationManger.delegate = nil
            updatingLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        if newLocation.horizontalAccuracy < 0{
            return
        }
        
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
        
            location = newLocation
            updateLabels()
            
            if newLocation.horizontalAccuracy <= locationManger.desiredAccuracy{
                print("xxx We are done!")
                stopLocationManager()
                configureGetButton()
            }
        }
        
    }
    
    func configureGetButton(){
        if updatingLocation {
            getButton.setTitle("Stop", forState: .Normal)
        
        
        } else {
            getButton.setTitle("Get my location", forState: .Normal)
        }
    }
    
    func updateLabels()
    {
        if let location = self.location {
            latitudeLable.text = String(format: "%.8f", location.coordinate.latitude)
            longtitudeLable.text = String(format: "%.8f", location.coordinate.longitude)
            
            tagButton.hidden = false
            messageLabel.text = ""
        } else {
            latitudeLable.text = ""
            longtitudeLable.text = ""
            addressLabel.text = ""
            tagButton.hidden = true
            
            let statusMessage : String
            if let error = lastLocationError {
                if error.domain == kCLErrorDomain && error.code == CLError.Denied.rawValue {
                    statusMessage = "Location Services Disabled"
                } else {
                    statusMessage = "Error Getting location"
                }
            } else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Services Disabled"
            } else if updatingLocation {
                statusMessage = "Searching....."
            } else {
                statusMessage = "Tap 'Get my location' to start"
            }
      
            messageLabel.text = statusMessage
        }
    }
    
    
    //TODO:
    
    
}

