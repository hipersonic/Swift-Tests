//
//  DXDataProvider.swift
//  Swift Tests
//
//  Created by Daniel Rangelov on 8/13/15.
//  Copyright (c) 2015 Daniel Rangelov. All rights reserved.
//

import UIKit

class DXDataProvider: NSObject {
    
    static let sharedInstance = DXDataProvider()
    
    var entries: NSMutableArray = []
    var path : String = ""
    
    
    override init() {
        //Setup LocationManager
        super.init()
        
        loadData()
    }
    
    // MARK: Convenience methods
    
    func loadData () {
        entries.removeAllObjects()
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        path = documentsDirectory.stringByAppendingPathComponent("Entries.plist")
        
        let fileManager = NSFileManager.defaultManager()
        if(!fileManager.fileExistsAtPath(path))
        {
            //Copy the plist from the bundle to the documents directory
            let bundle = NSBundle.mainBundle().pathForResource("Entries", ofType: "plist")
            fileManager.copyItemAtPath(bundle!, toPath: path, error:nil)
        }
        
        let plistEntries : NSArray = NSArray(contentsOfFile: path)!
        
        for dictEntry in plistEntries {
            let newEntry = DXEntryObject.initContentFromDictionary(dictEntry as! NSDictionary)
            entries.addObject(newEntry)
        }
    }

    func saveData () {
        entries.writeToFile(path, atomically: false)
    }
    
}
