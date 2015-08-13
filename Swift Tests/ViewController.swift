//
//  ViewController.swift
//  Swift Tests
//
//  Created by Daniel Rangelov on 8/10/15.
//  Copyright (c) 2015 Daniel Rangelov. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CellProtocol, AddEntryProtocol{
    @IBOutlet weak var tableView: UITableView!
    var entries: NSMutableArray = []
    var path : String = ""
    var indexPathUpdatedCell:NSIndexPath?
    
    func loadDataPlist(){
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.numberOfSections()
        
        loadDataPlist()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func onBarButtonMapPressed(sender: AnyObject) {
        var viewController = self.storyboard?.instantiateViewControllerWithIdentifier("MapVC") as! DXMapViewController;
        viewController.locations = NSArray()
        self.navigationController?.pushViewController(viewController, animated: true)
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("EntryCell", forIndexPath: indexPath) as! DXEntryTableViewCell
        
        var currentEntry = entries[indexPath.row] as! NSMutableDictionary
        if currentEntry["events"]  == nil {
            currentEntry["events"] = NSMutableArray()
        }
        var events = currentEntry["events"] as! NSMutableArray
        
        cell.delegate = self;
        cell.entryDescription = currentEntry
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var viewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailsVC") as! DXDetailsViewController;
        
        var currentEntry = entries[indexPath.row] as! NSMutableDictionary
        viewController.entryDescription = currentEntry
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func cellValueChanged(sender: DXEntryTableViewCell) {
        var indexPathRow = tableView.indexPathForCell(sender)?.row
        var dictionary = sender.entryDescription

        entries.removeObjectAtIndex(indexPathRow!)
        entries.insertObject(dictionary, atIndex: indexPathRow!)
        
        entries.writeToFile(path, atomically: false)
        
        let resultDictionary = NSMutableArray(contentsOfFile: path)
        //println("Saved Entries.plist file is --> \(resultDictionary)")
    }
    
    func cellAddEntryButtonPressed(sender: DXEntryTableViewCell) {
        indexPathUpdatedCell = tableView.indexPathForCell(sender)
        
        var viewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddEntryVC") as! DXAddEntryViewController;
        viewController.delegate = self;
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func addEntryControllerDidConfirmEntry(sender: DXAddEntryViewController) {
        
        if indexPathUpdatedCell != nil {
            var date =  NSDate()
            
            var currentEntry = entries[indexPathUpdatedCell!.row] as! NSMutableDictionary
            
            var events = currentEntry["events"] as! NSMutableArray
            
            var newEvent : DXEventObject = DXEventObject()
            newEvent.date = date;
            newEvent.location = sender.location
            newEvent.text = sender.textVewDescription.text
            newEvent.price = sender.price
            
            events.addObject(newEvent.dictionaryRepresentation())
            
            var indexPathRow = indexPathUpdatedCell!.row
            
            entries.removeObjectAtIndex(indexPathRow)
            entries.insertObject(currentEntry, atIndex: indexPathRow)
            
            entries.writeToFile(path, atomically: false)
            
            tableView.reloadData()
        }
        
        indexPathUpdatedCell = nil
    }
}

