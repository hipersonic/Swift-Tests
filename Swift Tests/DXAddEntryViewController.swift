//
//  DXAddEntryViewController.swift
//  Swift Tests
//
//  Created by Daniel Rangelov on 8/13/15.
//  Copyright (c) 2015 Daniel Rangelov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol AddEntryProtocol {
    func addEntryControllerDidConfirmEntry(sender:DXAddEntryViewController)
}


class DXAddEntryViewController: UIViewController {

    var delegate:AddEntryProtocol?
    
    @IBOutlet weak var textVewDescription: UITextView!
    @IBOutlet weak var segmentedControlPrice: UISegmentedControl!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var location:CLLocation?
    var price:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mapView.userTrackingMode = MKUserTrackingMode.Follow
        
        if DXLocationManager.sharedInstance.placemark != nil {
            var locationStr:NSMutableString = ""
            
            if DXLocationManager.sharedInstance.placemark?.country != nil {
                if locationStr.length > 0 {
                  locationStr.appendString(", ")
                }
                locationStr.appendString("\(DXLocationManager.sharedInstance.placemark!.country )")
            }
            
            if DXLocationManager.sharedInstance.placemark?.locality != nil {
                if locationStr.length > 0 {
                    locationStr.appendString(", ")
                }
                locationStr.appendString("\(DXLocationManager.sharedInstance.placemark!.locality)")
            }
            
            if DXLocationManager.sharedInstance.placemark?.subLocality != nil {
                if locationStr.length > 0 {
                    locationStr.appendString(", ")
                }
                locationStr.appendString("\(DXLocationManager.sharedInstance.placemark!.subLocality)")
            }
            
            if DXLocationManager.sharedInstance.placemark?.name != nil {
                if locationStr.length > 0 {
                    locationStr.appendString(", ")
                }
                locationStr.appendString("\(DXLocationManager.sharedInstance.placemark!.name)")
            } else {
                if DXLocationManager.sharedInstance.placemark?.thoroughfare != nil {
                    if locationStr.length > 0 {
                        locationStr.appendString(", ")
                    }
                    locationStr.appendString("\(DXLocationManager.sharedInstance.placemark!.thoroughfare)")
                }
                
                if DXLocationManager.sharedInstance.placemark?.subThoroughfare != nil {
                    if locationStr.length > 0 {
                        locationStr.appendString(", ")
                    }
                    locationStr.appendString("\(DXLocationManager.sharedInstance.placemark!.subThoroughfare)")
                }
            }
            
            lblLocation.text = locationStr as String
        }
        
        //Preset the position to skip map scrolling
        if DXLocationManager.sharedInstance.location != nil {
            //Cache location in case the device is moving
            location = DXLocationManager.sharedInstance.location
            
            let mapCenter : CLLocationCoordinate2D = DXLocationManager.sharedInstance.location!.coordinate
            mapView.centerCoordinate = mapCenter
            mapView.setRegion(MKCoordinateRegionMake(mapCenter, MKCoordinateSpanMake(0.01,0.01)), animated: true)
        }
        
        price = segmentedControlPrice.selectedSegmentIndex*10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapGestureHandler(sender: AnyObject) {
        self.view.endEditing(true)
    }

    @IBAction func onButtonAddPressed(sender: AnyObject) {
        price = segmentedControlPrice.selectedSegmentIndex*10
        self.navigationController?.popViewControllerAnimated(true)
        delegate?.addEntryControllerDidConfirmEntry(self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
