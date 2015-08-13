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
                let eventLoaded : DXEventObject = DXEventObject.initContentFromDictionary(event as! NSDictionary)
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
    }
    
   
    
    @IBAction func onBarButtonMapPressed(sender: AnyObject) {
        
        var locations : NSMutableArray = []
        
        for event in events {
            let tmpLocation : CLLocation = event.location
            locations.addObject(tmpLocation)
        }
        
        var viewController = self.storyboard?.instantiateViewControllerWithIdentifier("MapVC") as! DXMapViewController
        
        viewController.locations = locations
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateContents(description: NSDictionary) {
        var events = description["events"] as! NSMutableArray
        
        var daysPassed:Int = 0
        
        if events.count > 0 {
            var event:DXEventObject =  DXEventObject.initContentFromDictionary(events[0] as! NSDictionary)
            if event.date != nil {
                let dateFirst:NSDate = event.date!
                
                let cal = NSCalendar.currentCalendar()
                let unit:NSCalendarUnit = .CalendarUnitDay
                let components = cal.components(unit, fromDate: dateFirst, toDate: NSDate(), options: nil)
                
                daysPassed = components.day
            }
        }
        
        let daysString = daysPassed > 0 ? "in \(daysPassed) days" : ""
        lblDetails.text = events.count > 0 ? "\(events.count) entries \(daysString)" : "No entries"
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
        
        let event = events[indexPath.row] as! DXEventObject
        
        if event.date != nil {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            cell.lblDate?.text = dateFormatter.stringFromDate(event.date!);
        }
        
        if event.location != nil {
            CLGeocoder().reverseGeocodeLocation(event.location, completionHandler: {(placemarks, error)-> Void in
                if (error != nil) {
                    println("Reverse geocoder failed with error" + error.localizedDescription)
                    return
                }
                
                
                if placemarks.count > 0 {
                    let placemark : CLPlacemark = placemarks[0] as! CLPlacemark

                    var text = placemark.subLocality
                    
                    if text == nil {
                        text = placemark.thoroughfare
                    }
                    if text == nil {
                        text = placemark.name
                    }
                    if text == nil {
                        text = placemark.locality
                    }
                    if text == nil {
                        text = ""
                    }
                    
                    cell.lblLocation.text = text
                    
                } else {
                    println("Problem with the data received from geocoder")
                }
            })

            
        } else {
            cell.lblLocation.text = "Unknown Location"
        }
        
        
        return cell
    }
}
