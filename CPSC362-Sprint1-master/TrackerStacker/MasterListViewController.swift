//
//  MasterListViewController.swift
//  TrackerStacker
//
//  Created by Cindy Quach on 4/27/20.
//  Copyright © 2020 Cindy Quach. All rights reserved.
//

import UIKit
import CoreData

class MasterListViewController: UITableViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemsListCD = [Item]()
    
    let fetchItems: NSFetchRequest<Item> = Item.fetchRequest()
    let itemCD = Item(context: PersistenceService.context)
    
    
    
// DELETES EVERYTHING IN CORE DATA!
    func deleteAllData() {
        do {
            let items = try PersistenceService.context.fetch(self.fetchItems)
            print("Items in Core Data:")
            for i in items {
//                PersistenceService.context.delete(i)
                print(i.name)
            }
            print(items.count)
//            PersistenceService.saveContext()

        } catch {
            print(error)
        }
    }
}
