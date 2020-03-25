//
//  Item.swift
//  TrackerStacker
//
//  Created by Cindy Quach on 3/24/20.
//  Copyright © 2020 Cindy Quach. All rights reserved.
//

import UIKit

class Item: NSObject {
    
    var name: String
    var quantity: Int
    var notes: String?
    let dateCreated: Date
    let itemKey: String
    
    
    init(name: String, quantity: Int, notes: String?) {
        self.name = name
        self.quantity = quantity
        self.notes = notes
        self.dateCreated = Date()
        self.itemKey = UUID().uuidString
        
        super.init()
    }
}
