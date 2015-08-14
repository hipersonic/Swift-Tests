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
    func cellAddEntryButtonPressed(sender:DXEntryTableViewCell)
}

class DXEntryTableViewCell: UITableViewCell, UIAlertViewDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    
    var delegate:CellProtocol?
    
    var entryObject:DXEntryObject? {
        didSet {
            updateCellContents(entryObject!)
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
        /*
        let alertView = UIAlertView(
            title: "New Entry",
            message: "Add new entry?",
            delegate: self,
            cancelButtonTitle: "Cancel",
            otherButtonTitles: "Add"
        )
        
        alertView.show()
        */
        
        delegate?.cellAddEntryButtonPressed(self)
        
    }
    
    func updateCellContents(entryObject: DXEntryObject) {
        
        lblCount.text = "\(entryObject.events.count)"
        lblTitle.text = entryObject.name
        
        imgIcon.image = UIImage(named: entryObject.iconName! + ".png")
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        switch buttonIndex {
        case alertView.cancelButtonIndex :
            break
            
        case 1 :
            var date =  NSDate()
            
            var newEntry : DXEventObject = DXEventObject()
            newEntry.date = date;
            newEntry.location = DXLocationManager.sharedInstance.location
            newEntry.text = "New Entry"
            
            if entryObject != nil {
                entryObject!.events.addObject(newEntry)
                self.lblCount.text = "\(entryObject!.events.count)"
                delegate?.cellValueChanged(self)
            }
            
            //DXLocationManager.sharedInstance
            
            
        
        default :
            println("SWITCH: Missing statemant")
        }
    }
}
