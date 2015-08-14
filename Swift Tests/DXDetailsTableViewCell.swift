//
//  DXDetailsTableViewCell.swift
//  Swift Tests
//
//  Created by Daniel Rangelov on 8/11/15.
//  Copyright (c) 2015 Daniel Rangelov. All rights reserved.
//

import UIKit
import CoreLocation

class DXDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    var eventObject : DXEventObject? {
        didSet {
            if eventObject != nil {
                updateContents(eventObject!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateContents(event : DXEventObject) {
        
        if event.date != nil {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            lblDate?.text = dateFormatter.stringFromDate(event.date!);
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
                    
                    self.lblLocation.text = text
                    
                } else {
                    println("Problem with the data received from geocoder")
                }
            })
            
            
        } else {
            lblLocation.text = "Unknown Location"
        }
        
        lblPrice.text = "\(event.price)"
        
        lblDescription.text = event.text

    }
    
}
