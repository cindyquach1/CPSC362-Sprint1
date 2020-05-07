//
//  ItemsViewController.swift
//  TrackerStacker
//
//  Created by Cindy Quach on 3/11/20.
//  Copyright © 2020 Cindy Quach. All rights reserved.
//

//TODO: 5/3
// -fix bug --passing on correct info to DetailsVC (note: it works perfectly fine in MasterVC -> DetailsVC)

import UIKit
import CoreData

class ItemsViewController: UITableViewController, UINavigationControllerDelegate {

    var itemsListCD = [Item]()
    var imageStore = ImageStore()

    
    let fetchItems: NSFetchRequest<Item> = Item.fetchRequest()
    let itemCD = Item(context: PersistenceService.context)
    let category = Category(context: PersistenceService.context)

    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {

// Creates popup for adding new item
        let NewItemAlert = UIAlertController(title: "Add a new item!", message: "", preferredStyle: .alert)
        NewItemAlert.addTextField { (textField) in
            textField.placeholder = "Item Name"
            textField.keyboardType = .default
        }
        NewItemAlert.addTextField { (textField) in
            textField.placeholder = "Quantity"
            textField.keyboardType = .default
        }
        NewItemAlert.addTextField { (textField) in
            textField.placeholder = "Notes"
            textField.keyboardType = .default
        }
        NewItemAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        NewItemAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) -> Void in
            let itemName = NewItemAlert.textFields![0] as UITextField
            let itemQty = NewItemAlert.textFields![1] as UITextField
            let itemNotes = NewItemAlert.textFields![2] as UITextField

// Configure itemCD
            self.itemCD.name = itemName.text
            self.itemCD.quantity = Int64(itemQty.text!)!
            self.itemCD.notes = itemNotes.text
            self.itemCD.date = Date()
            PersistenceService.saveContext()
            self.itemsListCD.append(self.itemCD)
            
// Insert this new row into the table
            if let index = self.itemsListCD.firstIndex(of: self.itemCD){
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic) }
            
        }))
        
        self.present(NewItemAlert, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        do {
//            let items = try PersistenceService.context.fetch(self.fetchItems)
//            self.itemsListCD = items
//        for items in itemsListCD
//        {
//            if let idx = itemsListCD.firstIndex(where: { $0.value(forKey: "name") == nil }) {
//                itemsListCD.remove(at: idx)
//            }
//        }
//        } catch {
//            print(error)
//        }
        return itemsListCD.count
    }

    override func tableView(_ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
// Create an instance of UITableViewCell, with default appearance
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell

// Configure the cell with the Item
        cell.nameLabel.text = itemsListCD[indexPath.row].name
        cell.quantityLabel.text = String(itemsListCD[indexPath.row].quantity)
        
        

// Alert label for low stock when quantity is 0-3
        let quant = Int(cell.quantityLabel.text!)
        if quant! < 4 && quant! >= 0 {
            cell.LowStockLabel.isHidden = false
        } else {
            cell.LowStockLabel.isHidden = true
        }
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
// If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            
            let item = itemsListCD[indexPath.row]

            let title = "Delete?"
            let message = "Are you sure you want to delete this item?"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)

            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action) -> Void in

// Remove the item from core data
            PersistenceService.context.delete(item)
            PersistenceService.saveContext()

// Removes from array and table
            self.itemsListCD.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)

            })
            ac.addAction(deleteAction)
// Present the alert controller
            present(ac, animated: true, completion: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showItem"?:
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
            // Get the item associated with this row and pass it along
                let item = itemsListCD[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
//                detailViewController.imageStore = imageStore
            }
        default:
            preconditionFailure("Unexpected segue identifier.") }
    }
    
// DELETES EVERYTHING IN CORE DATA!
    func deleteAllData() {
        do {
            let items = try PersistenceService.context.fetch(self.fetchItems)
            print("Items in Core Data:")
            for i in items {
                PersistenceService.context.delete(i)
//                print(i.name)
            }
            print(items.count)
            PersistenceService.saveContext()

        } catch {
            print(error)
        }
    }

}
