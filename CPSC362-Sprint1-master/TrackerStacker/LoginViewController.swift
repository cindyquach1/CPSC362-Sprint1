//
//  LoginViewController.swift
//  TrackerStacker
//
//  Created by Cindy Quach on 3/11/20.
//  Copyright © 2020 Cindy Quach. All rights reserved.
//

import UIKit
import CoreData


class LoginViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var usersListCD = [User]()
    let fetchUsers: NSFetchRequest<User> = User.fetchRequest()
    
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
            var correctLogin = false
            
            let users = try PersistenceService.context.fetch(fetchUsers)
            self.usersListCD = users
            for user in usersListCD { if (RegEmail ==  user.email && RegPassword == user.password){
                //Takes user to next page if user info matches in database
                    let CategoriesVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesViewController")
                    self.navigationController?.pushViewController(CategoriesVC!, animated: true)
                    correctLogin = true
                    break
                }
                
            }
            //Creates alert for incorrect login info
            if(correctLogin == false)
            {
                let alert = UIAlertController(title: "Incorrect email or password", message: "", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))

                self.present(alert, animated: true)
            }
        } catch {
            print(error)
        }
        
    }

// Validating password requirements of capital and lowercase letters, numbers, symbols, and 8 min characters
    func validpassword(mypassword : String) -> Bool
    {
            let passwordreg =  ("(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[@#$%^&*]).{8,}")
            let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
            return passwordtesting.evaluate(with: mypassword)
    }


    @IBAction func CreateNewButton(_ sender: UIButton) {
        let RegName = " \(String(describing: NameTextField.text)) "
        let RegEmail = " \(String(describing: EmailTextField.text)) "
        let RegPassword = " \(String(describing: PasswordTextField.text)) "
        NameTextField.text = ""
        EmailTextField.text = ""
        PasswordTextField.text = ""
        
        let password = validpassword(mypassword: RegPassword)
        
// Popup checks if password passes all requirements
        if(password == false)
        {
            let alert = UIAlertController(title: "Choosing a password", message: "Your password must consist of at least: \n - 8 characters \n - Mix of capital and lowercase letters \n - 1 number \n - 1 symbol ", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))

            self.present(alert, animated: true)
        }

        let userCD = User(context: PersistenceService.context)
        userCD.name = RegName
        userCD.email = RegEmail
        userCD.password = RegPassword
        PersistenceService.saveContext()
        self.usersListCD.append(userCD)
    }
    
//something for the keyboard popup when clicking on the textfield, don't worry if the keyboard doesn't pop up on simulator, it's responding to your actual keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
// DELETES EVERYTHING IN CORE DATA!
    func deleteAllData() {
        do {
            let users = try PersistenceService.context.fetch(self.fetchUsers)
            print("Items in Core Data:")
            for i in users {
                PersistenceService.context.delete(i)
//                print(i.email!)
            }
            print(users.count)
            PersistenceService.saveContext()

        } catch {
            print(error)
        }
    }

}
