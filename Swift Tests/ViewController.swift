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
    var path : String = ""
    var indexPathUpdatedCell:NSIndexPath?
    
    
    // MARK: - View Related
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.numberOfSections()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    // MARK: - User Interaction
    
    @IBAction func onBarButtonMapPressed(sender: AnyObject) {
        var viewController = self.storyboard?.instantiateViewControllerWithIdentifier("MapVC") as! DXMapViewController;
        var allLocations = NSMutableArray()
        for entry in DXDataProvider.sharedInstance.entries {
            let tmpEntry = entry as! DXEntryObject
            
            allLocations.addObjectsFromArray(tmpEntry.locations() as [AnyObject])
        }
        viewController.locations = allLocations
        self.navigationController?.pushViewController(viewController, animated: true)
    }


    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DXDataProvider.sharedInstance.entries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("EntryCell", forIndexPath: indexPath) as! DXEntryTableViewCell
        
        var currentEntry = DXDataProvider.sharedInstance.entries[indexPath.row] as! DXEntryObject
        
        cell.delegate = self;
        cell.entryObject = currentEntry
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var viewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailsVC") as! DXDetailsViewController;
        
        var currentEntry = DXDataProvider.sharedInstance.entries[indexPath.row] as! DXEntryObject
        viewController.entryObject = currentEntry
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - Delegate Methods
    
    func cellAddEntryButtonPressed(sender: DXEntryTableViewCell) {
        indexPathUpdatedCell = tableView.indexPathForCell(sender)
        
        var viewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddEntryVC") as! DXAddEntryViewController;
        viewController.delegate = self;
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func addEntryControllerDidConfirmEntry(sender: DXAddEntryViewController) {
        
        if indexPathUpdatedCell != nil {
            var date =  NSDate()
            
            var currentEntry = DXDataProvider.sharedInstance.entries[indexPathUpdatedCell!.row] as! DXEntryObject
            
            var events = currentEntry.events
            
            var newEvent : DXEventObject = DXEventObject()
            newEvent.date = date;
            newEvent.location = sender.location
            newEvent.text = sender.textVewDescription.text
            newEvent.price = sender.price
            
            events.addObject(newEvent.dictionaryRepresentation())
            
            var indexPathRow = indexPathUpdatedCell!.row
            
            DXDataProvider.sharedInstance.entries.removeObjectAtIndex(indexPathRow)
            DXDataProvider.sharedInstance.entries.insertObject(currentEntry, atIndex: indexPathRow)
            
            DXDataProvider.sharedInstance.saveData()
        
            tableView.reloadData()
        }
        
        indexPathUpdatedCell = nil
    }
}

