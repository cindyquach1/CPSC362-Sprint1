//
//  ItemCell.swift
//  TrackerStacker
//
//  Created by Cindy Quach on 3/11/20.
//  Copyright © 2020 Cindy Quach. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var LowStockLabel: UILabel!
    
    override func awakeFromNib() {
    super.awakeFromNib()
        nameLabel?.adjustsFontForContentSizeCategory = true
        LowStockLabel?.adjustsFontForContentSizeCategory = true
        quantityLabel?.adjustsFontForContentSizeCategory = true
    }
}
