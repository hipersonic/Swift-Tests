//
//  DXEntryTableViewCell.swift
//  Swift Tests
//
//  Created by Daniel Rangelov on 8/10/15.
//  Copyright (c) 2015 Daniel Rangelov. All rights reserved.
//

import UIKit

protocol CellProtocol {
    func cellAddEntryButtonPressed(sender:DXEntryTableViewCell)
}

class DXEntryTableViewCell: UITableViewCell, UIAlertViewDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    
    var delegate:CellProtocol?
    
    // MARK: - Setters
    
    var entryObject:DXEntryObject? {
        didSet {
            updateCellContents(entryObject!)
        }
    }
    
    // MARK: - Cell Related
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    func updateCellContents(entryObject: DXEntryObject) {
        
        lblCount.text = "\(entryObject.events.count)"
        lblTitle.text = entryObject.name
        
        var imgName = entryObject.iconName!
        var image = UIImage(named: imgName)
        imgIcon.image = image
    }
    
    
    // MARK: - User Actions
    
    @IBAction func onButtonAddPressed(sender: AnyObject) {
        delegate?.cellAddEntryButtonPressed(self)
    }
}