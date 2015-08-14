//
//  DXLocationManager.swift
//  Swift Tests
//
//  Created by Daniel Rangelov on 8/12/15.
//  Copyright (c) 2015 Daniel Rangelov. All rights reserved.
//

import UIKit
import CoreLocation

class DXLocationManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = DXLocationManager()
    let locationManager = CLLocationManager()
    
    var location: CLLocation?
    var placemark: CLPlacemark?
    
    override init() {
        //Setup LocationManager
        super.init()
        
        startUpdatingLocation()
    }
    
    
    // MARK: - Convenince Methods
    
    func startUpdatingLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    
    // MARK: - Delegate methods
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)-> Void in
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            self.location = manager.location;
            
            if placemarks.count > 0 {
                self.placemark = placemarks[0] as? CLPlacemark
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
}
