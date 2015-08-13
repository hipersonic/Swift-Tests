//
//  DXDataProvider.swift
//  Swift Tests
//
//  Created by Daniel Rangelov on 8/13/15.
//  Copyright (c) 2015 Daniel Rangelov. All rights reserved.
//

import UIKit

class DXDataProvider: NSObject {
    
    var entries: NSMutableArray = []
    var path : String = ""
    
    func loadData(){
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
        entries = NSMutableArray(contentsOfFile: path)!
    }

    func saveData() {
        entries.writeToFile(path, atomically: false)
    }
    
}
