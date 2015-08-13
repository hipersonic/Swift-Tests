//
//  DXEntryObject.swift
//  Swift Tests
//
//  Created by Daniel Rangelov on 8/13/15.
//  Copyright (c) 2015 Daniel Rangelov. All rights reserved.
//

import UIKit

class DXEntryObject: NSObject {
    var iconName : String?
    var name : String?
    var date: NSDate?
    var events: NSMutableArray = []
    
    class func initContentFromDictionary(dictionary:NSDictionary) -> DXEntryObject {
        var entry = DXEntryObject()
        entry.restoreFromDictionary(dictionary)
        return entry
    }
    
    func restoreFromDictionary(dictionary:NSDictionary) {
        iconName = dictionary.objectForKey("icon_name") as? String
        name = dictionary.objectForKey("name") as? String
        
        let eventsNotParsed = dictionary["events"] as! NSMutableArray
        
        for event in eventsNotParsed {
            let eventLoaded : DXEventObject = DXEventObject.initContentFromDictionary(event as! NSDictionary)
            events.addObject(eventLoaded)
        }
        
    }
    
    func dictionaryRepresentation()-> NSDictionary {
        let result : NSMutableDictionary = [:]
        
        if iconName != nil {
            result.setValue(iconName, forKey:"icon_name")
        }
        
        if name != nil {
            result.setValue(name, forKey:"name")
        }
        
        var eventsAsDicts:NSMutableArray = []
        if events.count > 0 {
            for event in events {
                let tmpEvent:DXEventObject = event as! DXEventObject
                let eventDictRepresentation:NSDictionary = tmpEvent.dictionaryRepresentation()
                eventsAsDicts.addObject(eventDictRepresentation)
            }
        }
        
        result.setValue(eventsAsDicts, forKey: "events")
        
        return result
    }

}
