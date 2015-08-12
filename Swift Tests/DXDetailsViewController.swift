//
//  DXDetailsViewController.swift
//  Swift Tests
//
//  Created by Daniel Rangelov on 8/11/15.
//  Copyright (c) 2015 Daniel Rangelov. All rights reserved.
//

import UIKit
import CoreLocation

class DXDetailsViewController: UIViewController {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var events:NSMutableArray  = []
    
    var entryDescription:NSMutableDictionary = [:] {
        didSet {
            let tmpEvents = entryDescription["events"] as! NSMutableArray
            
            for event in tmpEvents {
                let eventLoaded : DXEntryObject = DXEntryObject.initContentForDictionary(event as! NSDictionary)
                events.addObject(eventLoaded)
            }
            
            if self.isViewLoaded() {
                updateContents(entryDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if (entryDescription.allKeys.count > 0) {
            updateContents(entryDescription)
        }
        
        runTests()
        
    }
    
    func runTests() {
        
        let location1:CLLocation = CLLocation(latitude: 42.677395, longitude: 23.425619)
        let location2:CLLocation = CLLocation(latitude: 42.679452, longitude: 23.437907)
        let location3:CLLocation = CLLocation(latitude: 42.672027, longitude: 23.428523)
        let location4:CLLocation = CLLocation(latitude: 42.676956, longitude: 23.434983)
        //---- Group 2
        let location5:CLLocation = CLLocation(latitude: 42.675956, longitude: 23.432983)
        let location6:CLLocation = CLLocation(latitude: 42.676834, longitude: 23.428074)
        let location7:CLLocation = CLLocation(latitude: 42.673964, longitude: 23.435569)
        let location8:CLLocation = CLLocation(latitude: 42.679417, longitude: 23.435959)
        //---- Group 3
        let location9:CLLocation = CLLocation(latitude: 42.719553, longitude: 23.254862)
        let location10:CLLocation = CLLocation(latitude: 42.722397, longitude: 23.257561)
        let location11:CLLocation = CLLocation(latitude: 42.720320, longitude: 23.248580)
        let location12:CLLocation = CLLocation(latitude: 42.716767, longitude: 23.257432)

        //---- Random locations
        let location13:CLLocation = CLLocation(latitude: 42.681552, longitude: 23.316422)
        let location14:CLLocation = CLLocation(latitude: 42.735540, longitude: 23.314362)
        
        let locations : NSMutableArray = [location1, location2, location3, location4, location5, location6, location7, location8, location9, location10, location11, location12, location13, location14]
        let locationsSorted : NSMutableArray = []
        
        var minDistance = DBL_MAX
        var centerLocation : CLLocation = locations[0] as! CLLocation
        let raduisCloseLocations : Double = 600
        let thresholdDistance = raduisCloseLocations*2
        
        //Group the locations into regions
        while locations.count > 0 {
            let location:CLLocation = locations[0] as! CLLocation;
            var pointsCluster:NSMutableArray = [location]
            locations.removeObject(location)
            
            //var currentDistance = 0.0
    
            for locationCompare in locations {
                let tmpDistance = location.distanceFromLocation(locationCompare as! CLLocation)
                println(tmpDistance)
                if tmpDistance < thresholdDistance {
                    println("Add object")
                    //currentDistance += tmpDistance
                    pointsCluster.addObject(locationCompare)
                    locations.removeObject(locationCompare)
                }
            }
            
            if pointsCluster.count > 0 {
                //pointsCluster.addObject(location)
                locationsSorted.addObject(pointsCluster)
            }
            
            /*
            if minDistance > currentDistance {
            minDistance = currentDistance
            centerLocation = location as! CLLocation
            }
            */

        }
        
        
        //Find the center points
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateContents(description: NSDictionary) {
        var events = description["events"] as! NSMutableArray
        
        var dateComponents : NSDateComponents
        
        /*
        if events.count > 0 {
            let dateFirst = events[0] as! NSDate
            dateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay, fromDate: dateFirst, toDate: NSDate(), options: NSCalendarOptions.allZeros)
        }
        */
        
        lblDetails.text = "\(events.count) in "
        lblTitle.text = description["name"] as! NSString as String
        var imgName = description["icon_name"] as! NSString as String
        imgIcon.image = UIImage(named: "\(imgName).png")
    }

    @IBAction func onButtonResetPressed(sender: AnyObject) {
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if (entryDescription.allKeys.count > 0) {
            var events = entryDescription["events"] as! NSMutableArray
            count = events.count
        }
        
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("DetailsCell", forIndexPath: indexPath) as! DXDetailsTableViewCell
        
        let event = events[indexPath.row] as! DXEntryObject
        
        if event.date != nil {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
            
            
            cell.textLabel?.text = dateFormatter.stringFromDate(event.date!);
        }
        
        
        return cell
    }
}
