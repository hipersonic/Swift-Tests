//
//  DXEntryTableViewCell.swift
//  Swift Tests
//
//  Created by Daniel Rangelov on 8/10/15.
//  Copyright (c) 2015 Daniel Rangelov. All rights reserved.
//

import UIKit

protocol CellProtocol {
    func cellValueChanged(sender:DXEntryTableViewCell)
}

class DXEntryTableViewCell: UITableViewCell, UIAlertViewDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    
    var delegate:CellProtocol?
    
    var entryDescription:NSMutableDictionary = [:] {
        didSet {
            updateCellContents(entryDescription)
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
   
    
    @IBAction func onButtonAddPressed(sender: AnyObject) {
        
        let alertView = UIAlertView(
            title: "New Entry",
            message: "Add new entry?",
            delegate: self,
            cancelButtonTitle: "Cancel",
            otherButtonTitles: "Add"
        )
        
        alertView.show()
        
    }
    
    func updateCellContents(description: NSDictionary) {
        
        var events = description["events"] as! NSMutableArray
        
        self.lblCount.text = "\(events.count)"
        self.lblTitle.text = description["name"] as! NSString as String
        var imgName = description["icon_name"] as! NSString as String
        self.imgIcon.image = UIImage(named: "\(imgName).png")
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        switch buttonIndex {
        case alertView.cancelButtonIndex :
            break
            
        case 1 :
            var date =  NSDate()
            
            var newEntry : DXEntryObject = DXEntryObject()
            newEntry.date = date;
            newEntry.location = DXLocationManager.sharedInstance.location
            newEntry.text = "New Entry"
            
            var events = entryDescription["events"] as! NSMutableArray
            events.addObject(newEntry.dictionaryRepresentation())
            
            self.lblCount.text = "\(events.count)"
            
            //DXLocationManager.sharedInstance
            
            delegate?.cellValueChanged(self)
        
        default :
            println("SWITCH: Missing statemant")
        }
    }
}
