//
//  DXDetailsTableViewCell.swift
//  Swift Tests
//
//  Created by Daniel Rangelov on 8/11/15.
//  Copyright (c) 2015 Daniel Rangelov. All rights reserved.
//

import UIKit

class DXDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
