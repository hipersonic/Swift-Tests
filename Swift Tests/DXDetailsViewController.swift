//
//  DXDetailsViewController.swift
//  Swift Tests
//
//  Created by Daniel Rangelov on 8/11/15.
//  Copyright (c) 2015 Daniel Rangelov. All rights reserved.
//

import UIKit
import CoreLocation

class DXDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblIncome: UILabel!
    
    // MARK: - Setters
    
    var entryObject:DXEntryObject?  {
        didSet {
            if self.isViewLoaded() {
                updateContents(entryObject!)
            }
        }
    }
    
    // MARK: - View Related
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        if entryObject != nil {
            updateContents(entryObject!)
        }
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateContents(entryObject: DXEntryObject) {
        
        var daysPassed:Int = 0
        
        if entryObject.events.count > 0 {
            var event =  entryObject.events[0] as! DXEventObject
            if event.date != nil {
                let dateFirst:NSDate = event.date!
                
                let cal = NSCalendar.currentCalendar()
                let unit:NSCalendarUnit = .CalendarUnitDay
                let components = cal.components(unit, fromDate: dateFirst, toDate: NSDate(), options: nil)
                
                daysPassed = components.day
            }
        }
        
        let daysString = daysPassed > 0 ? "in \(daysPassed) days" : ""
        lblDetails.text = entryObject.events.count > 0 ? "\(entryObject.events.count) entries \(daysString)" : "No entries"
        lblTitle.text = entryObject.name
        
        var imgName = entryObject.iconName!
        var image = UIImage(named: imgName)
        imgIcon.image = image
        
        lblIncome.text = "Income: \(entryObject.allEventsIncomeSum())"
    }
    
    
    // MARK: - User Actions
    
    @IBAction func onBarButtonMapPressed(sender: AnyObject) {
        
        var viewController = self.storyboard?.instantiateViewControllerWithIdentifier("MapVC") as! DXMapViewController
        
        if entryObject != nil {
            viewController.locations = entryObject!.locations()
        }
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
  
    
    // MARK: - TableView Delegate and DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int = 0
        if entryObject != nil {
            count = entryObject!.events.count
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("DetailsCell", forIndexPath: indexPath) as! DXDetailsTableViewCell
        
        let event = entryObject?.events[indexPath.row] as! DXEventObject
        cell.eventObject = event
        return cell
    }
    
}
