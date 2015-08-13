//
//  DXMapViewController.swift
//  Swift Tests
//
//  Created by Daniel Rangelov on 8/12/15.
//  Copyright (c) 2015 Daniel Rangelov. All rights reserved.
//

import UIKit
import MapKit

class DXMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let raduisCloseLocations : Double = 1000
    
    
    var locations:NSArray = [] {
        didSet {
            if self.isViewLoaded() {
                loadLocations(locations)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if locations.count > 0 {
            loadLocations(locations)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - User logic
    
    func sortLocationsIntoRegions(locationsUnSorted: NSArray) -> NSArray {
        
        let locationsUnSorted : NSMutableArray = NSMutableArray(array:locations)
        let locationsSorted : NSMutableArray = []
        
        //Divide locations into regions
        while locationsUnSorted.count > 0 {
            let location:CLLocation = locationsUnSorted[0] as! CLLocation;
            locationsUnSorted.removeObject(location)
            
            var pointsCluster:NSMutableArray = [location]
            
            var currentDistance = 0.0
            
            for locationCompare in locationsUnSorted {
                let tmpDistance = location.distanceFromLocation(locationCompare as! CLLocation)
                if tmpDistance < raduisCloseLocations {
                    currentDistance += tmpDistance
                    pointsCluster.addObject(locationCompare)
                    locationsUnSorted.removeObject(locationCompare)
                }
            }
            
            if pointsCluster.count > 0 {
                locationsSorted.addObject(pointsCluster)
            }
        }
        
        
        //Add region circle overlay
        for locationsRegioned in locationsSorted {
            let currentRegion:NSArray = locationsRegioned as! NSArray
            
            if currentRegion.count > 1 {
                var minDistance = DBL_MAX
                var centerLocation : CLLocation = currentRegion[0] as! CLLocation
                
                for location in currentRegion {
                    var currentDistance = 0.0
                    
                    for locationCompare in locationsUnSorted {
                        if location as! CLLocation != locationCompare as! CLLocation {
                            let tmpDistance = location.distanceFromLocation(locationCompare as! CLLocation)
                            currentDistance += tmpDistance
                        }
                        
                        if minDistance > currentDistance {
                            minDistance = currentDistance
                            centerLocation = location as! CLLocation
                        }
                    }
                }
                
                var circle = MKCircle(centerCoordinate: centerLocation.coordinate, radius:raduisCloseLocations as CLLocationDistance)
                self.mapView.addOverlay(circle)
            }
        }

        
        return locationsSorted
    }
    
    func loadLocations(locations: NSArray) {
        
        let locationsSorted : NSArray = sortLocationsIntoRegions(locations)
        
        for var i = 0; i < locationsSorted.count; i++  {
            var regionLocations:NSArray = locationsSorted.objectAtIndex(i) as! NSArray
            
            var pinColor:MKPinAnnotationColor = .Red
            
            //Pick a pin color if it is a region
            if regionLocations.count > 1 {
                switch i%2 {
                case 0 : pinColor = .Green
                default: pinColor = .Purple
                }
            }
            
            //Add the pins for the group
            for tmpLocation in regionLocations as NSArray {
                var location = tmpLocation as! CLLocation
                
                var point = DXPointAnnotation()
                
                point.coordinate = location.coordinate
                point.title = "Test"
                point.subtitle = "Vendor"
                point.color = pinColor
                mapView.addAnnotation(point)
                
            }
        }
        
        
        //Span of the map
        let mapCenter : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 42.697696, longitude: 23.321788)
        mapView.centerCoordinate = mapCenter
        mapView.setRegion(MKCoordinateRegionMake(mapCenter, MKCoordinateSpanMake(0.4,0.4)), animated: true)

    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if (annotation.isKindOfClass(MKUserLocation)){
            return nil
        }
        
        var customAnnotation : DXPointAnnotation = annotation as! DXPointAnnotation
        
        var myPin = mapView.dequeueReusableAnnotationViewWithIdentifier("MyIdentifier") as? MKPinAnnotationView
        if myPin != nil {
            myPin?.pinColor = customAnnotation.color
            return myPin
        }
        
        myPin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "MyIdentifier")
        myPin?.pinColor = customAnnotation.color
        return myPin
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if (overlay is MKCircle) {
            var pr = MKCircleRenderer(overlay: overlay)
            pr.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.6)
            pr.fillColor = UIColor.blueColor().colorWithAlphaComponent(0.1)
            pr.lineWidth = 1
            return pr
        }
        return nil
    }
}
