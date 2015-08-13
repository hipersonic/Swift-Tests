//
//  DXEventObject.swift
//  Swift Tests
//
//  Created by Daniel Rangelov on 8/12/15.
//  Copyright (c) 2015 Daniel Rangelov. All rights reserved.
//

import UIKit
import CoreLocation

class DXEventObject: NSObject {
    
    var location : CLLocation?
    var text : String?
    var date: NSDate?
    var price: Int = 0
    
    class func initContentFromDictionary(dictionary:NSDictionary) -> DXEventObject {
        var entry = DXEventObject()
        entry.restoreFromDictionary(dictionary)
        return entry
    }
    
    func restoreFromDictionary(dictionary:NSDictionary) {
        text = dictionary.objectForKey("text") as? String
 
        date = dictionary.objectForKey("date") as? NSDate
        
        let locationLat = dictionary.objectForKey("locationLat") as? Double
        let locationLng = dictionary.objectForKey("locationLng") as? Double
        
        if (locationLat != nil && locationLng != nil) {
            location = CLLocation(latitude: locationLat!, longitude: locationLng!)
        }
        
        var value = dictionary.objectForKey("price") as? Int
        if (value != nil) {
            price = value!
        }
    }
    
    func dictionaryRepresentation()-> NSDictionary {
        let result : NSMutableDictionary = [:]
        
        if location != nil {
            result.setValue(location?.coordinate.latitude, forKey:"locationLat")
            result.setValue(location?.coordinate.longitude, forKey:"locationLng")
        }
        
        if text != nil {
            result.setValue(text, forKey:"text")
        }
        
        if date != nil {
            result.setValue(date, forKey:"date")
        }
        
        if price > 0 {
            result.setValue(price, forKey: "price")
        }
        
        return result
    }
}

