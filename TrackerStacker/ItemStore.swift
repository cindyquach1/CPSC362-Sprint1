//
//  ItemStore.swift
//  TrackerStacker
//
//  Created by Cindy Quach on 3/24/20.
//  Copyright © 2020 Cindy Quach. All rights reserved.
//

import Foundation
import UIKit

class ItemStore {
    var allItems = [Item]()
    
    func createItem(itemName:String, itemQty:Int, itemNotes:String? ) -> Item {
        let newItem = Item(
            name: itemName,
            quantity: itemQty,
            notes: itemNotes
        )
        allItems.append(newItem)
        return newItem
    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.firstIndex(of: item) {
            allItems.remove(at: index)
        }
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        
        if fromIndex == toIndex {
            return
        }
        // Get reference to object being moved so you can reinsert it
        let movedItem = allItems[fromIndex]
        // Remove item from array
        allItems.remove(at: fromIndex)
        // Insert item in array at new location
        allItems.insert(movedItem, at: toIndex)
    }
}
