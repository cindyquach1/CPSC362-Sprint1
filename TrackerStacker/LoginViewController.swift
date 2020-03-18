//
//  LoginViewController.swift
//  TrackerStacker
//
//  Created by Cindy Quach on 3/11/20.
//  Copyright © 2020 Cindy Quach. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var EmailTextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!
 
    //For the keyboard to go away when anywhere else on the screen is tapped
    @IBAction func backgroundTapped1(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func CreateNewAccount(_ sender: UIButton) {
        let outputLabel = " \(String(describing: EmailTextField.text)) \(PasswordTextField.text) "
        EmailTextField.text = ""
        PasswordTextField.text = ""
        print(outputLabel)
    //* Add new account info to file; Should create a textfile to store info into *
    }
    
    @IBAction func Login(_ sender: UIButton) {
        
        let outputLabel = " \(String(describing: EmailTextField.text)) \(PasswordTextField.text) "
        EmailTextField.text = ""
        PasswordTextField.text = ""
        print(outputLabel)
        
    //* Check if login info is valid through text file, if so, go to next segue
    //if not, create alert of some kind for incorrect login info *
        
    // next segue (page)
        performSegue(withIdentifier: "FirstSegue", sender: self)
        
    }
    
//something for the keyboard popup when clicking on the textfield, don't worry if the keyboard doesn't pop up on simulator, it's responding to your actual keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//loads screen
    override func viewDidLoad() {
        super.viewDidLoad()
        EmailTextField.delegate = self
        PasswordTextField.delegate = self
    }
    
}
