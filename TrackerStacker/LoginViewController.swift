//
//  LoginViewController.swift
//  TrackerStacker
//
//  Created by Cindy Quach on 3/11/20.
//  Copyright © 2020 Cindy Quach. All rights reserved.
//

import UIKit
import SQLite

class LoginViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var database: Connection!
    
    let usersTable = Table("users")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let email = Expression<String>("email")
    let password = Expression<String>("password")
    
    @IBOutlet var NameTextField: UITextField!
    @IBOutlet var EmailTextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!
    
//For the keyboard to go away when anywhere else on the screen is tapped
    @IBAction func backgroundTapped1(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func Login(_ sender: UIButton) {
        let RegEmail = " \(String(describing: EmailTextField.text)) "
        let RegPassword = " \(String(describing: PasswordTextField.text)) "
        EmailTextField.text = ""
        PasswordTextField.text = ""

//Check if login info is valid through text file, if so, go to next segue
//if not, create alert of some kind for incorrect login info
        do {
            let users = try self.database.prepare(self.usersTable)
            for user in users {
                if (RegEmail == "\(user[self.email])" && RegPassword == "\(user[self.password])") {
                //Takes user to next page if user info matches in database
                    let CategoriesVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesViewController")
                    self.navigationController?.pushViewController(CategoriesVC!, animated: true)
                    break
                }
                else {
//Creates alert for incorrect login info
                    let alert = UIAlertController(title: "Incorrect email or password", message: "", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))

                    self.present(alert, animated: true)
                }
            }
        } catch {
            print(error)
        }
        
//Prints out user info from database
        do {
            let users = try self.database.prepare(self.usersTable)
            for user in users {
                print("userID: \(user[self.id]),  Name: \(user[self.name]), Email: \(user[self.email]), Password: \(user[self.password])")
            }
            } catch {
                print(error)
            }
    }
    
    @IBAction func CreateNewButton(_ sender: UIButton) {
        let RegName = " \(String(describing: NameTextField.text)) "
        let RegEmail = " \(String(describing: EmailTextField.text)) "
        let RegPassword = " \(String(describing: PasswordTextField.text)) "
        NameTextField.text = ""
        EmailTextField.text = ""
        PasswordTextField.text = ""

//Create database table (Use only once, then comment out)
//        let createTable = self.usersTable.create { (table) in
//            table.column(self.id, primaryKey: true)
//            table.column(self.name)
//            table.column(self.email, unique: true)
//            table.column(self.password)
//        }
//
//        do {
//            try self.database.run(createTable)
//            print("Created Table")
//        } catch {
//            print(error)
//        }

//Adds new user to table
        let insertUser = self.usersTable.insert(self.name <- RegName, self.email <- RegEmail, self.password <- RegPassword)
        do {
            try self.database.run(insertUser)
            print("INSERTED USER")
        } catch {
            print(error)
        }

        do {
            let users = try self.database.prepare(self.usersTable)
            for user in users {
                print("userID: \(user[self.id]), Name: \(user[self.name]), Email: \(user[self.email]), Password: \(user[self.password])")
            }
        } catch {
            print(error)
        }
    }
    
    
//something for the keyboard popup when clicking on the textfield, don't worry if the keyboard doesn't pop up on simulator, it's responding to your actual keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//Loads screen
    override func viewDidLoad() {
        super.viewDidLoad()        
//Connects to database
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            print(fileUrl)
        } catch {
            print(error)
        }
    }
}
