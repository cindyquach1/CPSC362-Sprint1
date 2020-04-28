//
//  DetailViewController.swift
//  TrackerStacker
//
//  Created by Cindy Quach on 3/11/20.
//  Copyright © 2020 Cindy Quach. All rights reserved.
//


import UIKit
import CoreData

// TODO: 4/4
// -Connect relationships properly
// -Details page--passing on the right item info
// -Save changes on details page
// -title matching for page selections
//      -fix date created
// -images --save to core data as well



class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var itemsListCD = [Item]()
    let fetchItems: NSFetchRequest<Item> = Item.fetchRequest()
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var quantityField: UITextField!
    @IBOutlet var notesField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        // If the device has a camera, take a picture; otherwise,
        // just pick from photo library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
        }
        else {
                imagePicker.sourceType = .photoLibrary
        }
        imagePicker.delegate = self
        
        //Place image picker on the screen
        present(imagePicker, animated: true, completion: nil)
    }

    var imageStore: ImageStore!
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        do {
            
// TODO: Fix this: prepare segue, get item selected from prev VC
//            let items = try PersistenceService.context.fetch(self.fetchItems)
//            self.itemsListCD = items
            nameField.text = item.name
            quantityField.text = item.notes
            notesField.text = String(item.quantity)
            dateLabel.text = dateFormatter.string(from: item.date!)
//        } catch {
//            print(error)
//        }
        
        // Get the item key
//        let key = item.itemKey
        // If there is an associated image with the item
        // display it on the image view
//        let imageToDisplay = imageStore.image(forKey: key)
//        imageView.image = imageToDisplay
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Clear first responder
        view.endEditing(true)
        
        // "Save" changes to item
//        item.name = nameField.text ?? ""
//        item.notes = quantityField.text
//        if let valueText = notesField.text,
//            let value = numberFormatter.number(from: valueText) { item.quantity = value.intValue
//        } else {
//            item.quantity = 0 }
//        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
// Get picked image from info dictionary
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
// Store the image in the ImageStore for the item's key
//        imageStore.setImage(image, forKey: item.itemKey)

// Put that image on the screen in the image view
        imageView.image = image
// Take image picker off the screen -
// you must call this dismiss method
        dismiss(animated: true, completion: nil)
    }
}
}
