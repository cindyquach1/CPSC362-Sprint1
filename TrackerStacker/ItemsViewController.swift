//
//  ItemsViewController.swift
//  TrackerStacker
//
//  Created by Cindy Quach on 3/11/20.
//  Copyright © 2020 Cindy Quach. All rights reserved.
//

import UIKit
import SQLite

class ItemsViewController: UITableViewController, UINavigationControllerDelegate {

//TODO: Create Items DB here, pass Category name from CategoriesVC as DB name

//Receives categoriesList from CategoriesVC
    var categoryNames = [String]()
    
    var itemsList: ItemStore!
    
    var imageStore = ImageStore()
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
//Creates popup for adding new item
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
            var itemName = NewItemAlert.textFields![0] as UITextField
            var itemQty = NewItemAlert.textFields![1] as UITextField
            var itemNotes = NewItemAlert.textFields![2] as UITextField
            
            var x = itemName.text!
            var y = Int(itemQty.text!)
            var z = String?(itemNotes.text!)

//Add new category into categoriesList array
            self.itemsList.createItem(itemName: x, itemQty: y!, itemNotes: z)
            
//Insert this new row into the table
            if let index = self.itemsList.firstIndex(of: itemName.text!) {
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic) }
        }))
        
        self.present(NewItemAlert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return itemsList.count
    }

    override func tableView(_ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an instance of UITableViewCell, with default appearance
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        // Set the text on the cell with the description of the item // that is at the nth index of items, where n = row this cell
        // will appear in on the tableview
        let item = itemsList[indexPath.row]
        // Configure the cell with the Item
        cell.nameLabel.text = item
//        cell.quantityLabel.text = 
        
        
//Alert label for low stock when quantity is 0-3
//        cell.quantityLabel.text = qtyList[0]
//        let quant = qtyList[0]
//        if quant! < 4 && quant! >= 0{
//            cell.LowStockLabel.isHidden = false
//        } else {
//            cell.LowStockLabel.isHidden = true
//        }
        
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
            let item = itemsList[indexPath.row]
            
//            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action) -> Void in
                
        // Remove the item from the store
//            self.itemsList(item)


        // Also remove that row from the table view with an animation
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        })
            ac.addAction(deleteAction)
            // Present the alert controller
            present(ac, animated: true, completion: nil)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
}

