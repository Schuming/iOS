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
        
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManger.startUpdatingLocation()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        updateLabels()
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
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        
        location = newLocation
        updateLabels()
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
            messageLabel.text = "Tap 'Get my location' to start"
        }
    }

    //TODO:


}

