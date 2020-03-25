//
//  CategoriesViewController.swift
//  TrackerStacker
//
//  Created by Cindy Quach on 3/22/20.
//  Copyright © 2020 Cindy Quach. All rights reserved.
//

import UIKit
import SQLite

class CategoriesViewController: UITableViewController, UINavigationControllerDelegate {
    
    var categoriesList = [String]()

//TODO: dynamic greeting username replace w/ actual name
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
//Creates popup for adding new category
        let NewCategoryAlert = UIAlertController(title: "Add a new category!", message: "", preferredStyle: .alert)
            NewCategoryAlert.addTextField { (textField) in
            textField.placeholder = "Category Name"
            textField.keyboardType = .default
        }
        NewCategoryAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        NewCategoryAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) -> Void in
            let categoryName = NewCategoryAlert.textFields![0] as UITextField
//Add new category into categoriesList array
            self.categoriesList.append(categoryName.text!)
            
//Insert this new row into the table
            if let index = self.categoriesList.firstIndex(of: categoryName.text!) {
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic) }
        }))
        self.present(NewCategoryAlert, animated: true)
    }

//Loads screen
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }
    
//Returns number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.categoriesList.count
    }

//Displays table cell
    override func tableView(_ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let dequeueCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") {
            cell = dequeueCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CategoryCell")
        }

        let name = self.categoriesList[indexPath.row]
        cell.textLabel?.text = name

        return cell
    }
    
//Delete a category by swiping left on item
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
// If the table view is asking to commit a delete command
        if editingStyle == .delete {
            let category = categoriesList[indexPath.row]
            
            let title = "Delete?"
            let message = "Are you sure you want to delete this item?"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)

            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action) -> Void in
                // Remove the item from the store
                if let index = self.categoriesList.firstIndex(of: category) {
                    self.categoriesList.remove(at: index)
                }

            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        })
            ac.addAction(deleteAction)
            // Present the alert controller
            present(ac, animated: true, completion: nil)
        }
    }
    
//Segue to ItemsViewController: to pass the categoriesList array data to ItemsViewController file
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let itemsVC = segue.destination as? ItemsViewController else { return }
        itemsVC.categoryNames = categoriesList
    }

//Logout user
    @objc func back(sender: UIBarButtonItem) {
    // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(CategoriesViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
 
}
