//
//  MasterListViewController.swift
//  TrackerStacker
//
//  Created by Cindy Quach on 4/27/20.
//  Copyright © 2020 Cindy Quach. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class MasterListViewController: UITableViewController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searching = false
    var searchedItem = [Item]()
    var itemsListCD = [Item]()
    
    let fetchItems: NSFetchRequest<Item> = Item.fetchRequest()
    let itemCD = Item(context: PersistenceService.context)
    let category = Category(context: PersistenceService.context)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        deleteAllData()
        do {
            let items = try PersistenceService.context.fetch(self.fetchItems)
            self.itemsListCD = items
        for items in itemsListCD
        {
            if let idx = itemsListCD.firstIndex(where: { $0.value(forKey: "name") == nil }) {
                itemsListCD.remove(at: idx)
            }
        }
        } catch {
            print(error)
        }
        
        if searching {
            return searchedItem.count
        }
        else {
            return itemsListCD.count
        }
    }

    override func tableView(_ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
// Configure the cell with the Item
        if itemsListCD[indexPath.row].name != nil
        {
            // Create an instance of UITableViewCell, with default appearance
            let cell = tableView.dequeueReusableCell(withIdentifier: "MasterItemCell", for: indexPath) as! ItemCell
            
            if searching {
                cell.nameLabel.text = self.searchedItem[indexPath.row].name
                cell.quantityLabel.text = String(searchedItem[indexPath.row].quantity)
            } else {
                cell.nameLabel.text = self.itemsListCD[indexPath.row].name
                cell.quantityLabel.text = String(itemsListCD[indexPath.row].quantity)
            }
            
    // Alert label for low stock when quantity is 0-3
        
            let quant = Int(cell.quantityLabel.text!)
            if quant! < 4 && quant! >= 0 {
                cell.LowStockLabel.isHidden = false
            } else {
                cell.LowStockLabel.isHidden = true
            }

            return cell
        }
        
        return UITableViewCell()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showMasterItem"?:
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
            // Get the item associated with this row and pass it along
                let item = itemsListCD[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
            }
        default:
            preconditionFailure("Unexpected segue identifier.") }
    }

    @IBAction func exportList(_ sender: UIBarButtonItem) {
        let exportString = createExportString()
        saveAndExport(exportString: exportString)
    }
    
    
    func createExportString() -> String {
        
        var itemDate: Date?
        var itemName: String?
        var itemQty: Int?
        var itemNote: String?
        
        var export: String = NSLocalizedString("Date,Item Name,Quantity,Note \n", comment: "")
        
        for i in itemsListCD as [NSManagedObject]{
            if let name = i.value(forKey: "name")
            {
                itemName = name as? String
            }
            if let qty = i.value(forKey: "quantity")
            {
                itemQty = qty as? Int
            }
            if let note = i.value(forKey: "notes")
            {
                itemNote = note as? String
            }
            if let date = i.value(forKey: "date")
            {
                itemDate = date as? Date
            }
            export += "\(itemDate!),\(itemName!),\(itemQty!),\(itemNote!) \n"
        }
        print("Successfully exported!")
        return export
    }
    
    func saveAndExport(exportString: String)
    {
        let exportFilePath = NSTemporaryDirectory() + "myItemsList.csv"
        let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
        FileManager.default.createFile(atPath: exportFilePath, contents: NSData() as Data, attributes: nil)
        var fileHandler: FileHandle? = nil
        do{
            fileHandler = try FileHandle(forWritingTo:exportFileURL as URL)
        } catch{
            print("Error with file handling")
        }
        
        if fileHandler != nil{
            fileHandler!.seekToEndOfFile()
            let csvData = exportString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            fileHandler!.write(csvData!)
            fileHandler!.closeFile()
            let firstActivityItem = NSURL(fileURLWithPath: exportFilePath)
                let activityViewController : UIActivityViewController = UIActivityViewController(
                    activityItems: [firstActivityItem], applicationActivities: nil)
                activityViewController.excludedActivityTypes = [
                    UIActivity.ActivityType.assignToContact,
                    UIActivity.ActivityType.saveToCameraRoll,
                ]

                self.present(activityViewController, animated: true, completion: nil)
            }
            print("Sucessfully file handled!")
    }
    
// DELETES EVERYTHING IN CORE DATA!
    func deleteAllData() {
        do {
            let items = try PersistenceService.context.fetch(self.fetchItems)
            print("Items in Core Data:")
            for i in items as [NSManagedObject]{
//                PersistenceService.context.delete(i)
                if let name = i.value(forKey: "name")
                {
                    print(name)
                }
            }
            print(items.count)
//            PersistenceService.saveContext()

        } catch {
            print(error)
        }
    }
    
}

extension MasterListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedItem = itemsListCD.filter({$0.name!.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
}
