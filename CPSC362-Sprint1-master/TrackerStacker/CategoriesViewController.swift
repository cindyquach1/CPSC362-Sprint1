//
//  CategoriesViewController.swift
//  TrackerStacker
//
//  Created by Cindy Quach on 3/22/20.
//  Copyright © 2020 Cindy Quach. All rights reserved.
//


import UIKit
import CoreData

class CategoriesViewController: UITableViewController, UINavigationControllerDelegate {
    
    var categoriesListCD = [Category]()
    let fetchCategories: NSFetchRequest<Category> = Category.fetchRequest()
    let categoriesCD = Category(context: PersistenceService.context)
    let user = User(context: PersistenceService.context)
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
// Creates popup for adding new category
        let NewCategoryAlert = UIAlertController(title: "Add a new category!", message: "", preferredStyle: .alert)
            NewCategoryAlert.addTextField { (textField) in
            textField.placeholder = "Category Name"
            textField.keyboardType = .default
        }
        NewCategoryAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        NewCategoryAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) -> Void in
            let categoryName = NewCategoryAlert.textFields![0] as UITextField
            
// Configure categoriesCD
            self.categoriesCD.item = String(categoryName.text!)
            PersistenceService.saveContext()
            self.categoriesListCD.append(self.categoriesCD)
            
// Links category to user
            self.user.addToCategory(self.categoriesCD)
            
// Insert this new row into the table
            if let index = self.categoriesListCD.firstIndex(of: self.categoriesCD){
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic) }
        }))
        self.present(NewCategoryAlert, animated: true)
    }

// Loads screen
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }
    
// Returns number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return categoriesListCD.count
    }

// Displays table cell
    override func tableView(_ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let dequeueCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") {
            cell = dequeueCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CategoryCell")
        }

        cell.textLabel!.text = categoriesListCD[indexPath.row].item
        return cell
    }
    
// Delete a category by swiping left on item
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
// If the table view is asking to commit a delete command
        if editingStyle == .delete {
            
            let selCategory = categoriesListCD[indexPath.row]
            
            let title = "Delete?"
            let message = "Are you sure you want to delete this item?"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)

            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action) -> Void in
// Remove the item from core data
                PersistenceService.context.delete(selCategory)
                PersistenceService.saveContext()
                
// Removes from array and table
                self.categoriesListCD.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)

                self.user.removeFromCategory(selCategory)

            })
            ac.addAction(deleteAction)
            // Present the alert controller
            present(ac, animated: true, completion: nil)
        }
    }
    
    
//Logout user
    @objc func back(sender: UIBarButtonItem) {
    // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(CategoriesViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
// DELETES EVERYTHING IN CORE DATA!
    func deleteAllData() {
        do {
            let categories = try PersistenceService.context.fetch(self.fetchCategories)
            print("cat:")
            for cat in categories {
                PersistenceService.context.delete(cat)
                print(cat.item)
            }
            print(categories.count)
            PersistenceService.saveContext()

        } catch {
            print(error)
        }
    }
 
}
