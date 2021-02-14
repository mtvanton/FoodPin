//
//  NewRestaurantController.swift
//  FoodPin
//
//  Created by pangborn on 7/17/20.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit
import CoreData


class NewRestaurantController: UITableViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet var nameTextField: RoundedTextField! {
        didSet {
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
        }
    }
    
    @IBOutlet var typeTextField: RoundedTextField! {
        didSet {
            typeTextField.tag = 2
            typeTextField.delegate = self
        }
    }
    
    @IBOutlet var addressTextField: RoundedTextField! {
        didSet {
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }
    
    
    @IBOutlet var phoneTextField: RoundedTextField! {
        didSet {
            phoneTextField.tag = 4
            phoneTextField.delegate = self
        }
    }
    
    @IBOutlet var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.tag = 5
            descriptionTextView.layer.cornerRadius = 5.0
            descriptionTextView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var photoImageView:UIImageView!
    
    var restaurant:RestaurantMO!
    
    //MARK: - camera or photo library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFit
            photoImageView.clipsToBounds = true
        }
        
        //auto layout constraint
        
        let leadingConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .leading, relatedBy: .equal, toItem: photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)

        leadingConstraint.isActive = true
        let trailingConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .trailing, relatedBy: .equal, toItem: photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        let topConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .top, relatedBy: .equal, toItem: photoImageView.superview, attribute: .top, multiplier: 1, constant: 0)

        topConstraint.isActive = true
        let bottomConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .bottom, relatedBy: .equal, toItem: photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)

        bottomConstraint.isActive = true
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - save button is pressed
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        // havent implemented phone, description, and address as part of validation
        
        if (nameTextField.text == "" || typeTextField.text == "") {
            let alert = UIAlertController(title: "Fill all fields", message: "one or few of these fields is blank", preferredStyle: .alert)
            let action = UIAlertAction(title: "Return", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            return
        }
      
        //saving core data
        //just do name, type, and image first
        //this pngData() shit costs alot, one image is about 11.4 MB
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            restaurant = RestaurantMO(context: appDelegate.persistentContainer.viewContext)
            restaurant.name = nameTextField.text
            restaurant.type = typeTextField.text
            
            if let restaurantImage = photoImageView.image {
                restaurant.image = restaurantImage.pngData()
            }
            
            print("Saving data to context ...")
            
            appDelegate.saveContext()
        }
        
        
        print("Name: \(nameTextField.text ?? "" ) ")
        print("Restaurant type: \(typeTextField.text ?? "") ")
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure navigation bar appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        
        //Exercise 1 - chapter 18
        tableView.separatorStyle = .none
        if let customFont = UIFont(name: "Rubik-Medium", size: 35.0) {
        navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue:60), NSAttributedString.Key.font: customFont ]
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose it bitxh", preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    
                    //p. 553
                    imagePicker.delegate = self
                    
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    
                    //p. 553
                    imagePicker.delegate = self
                    
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true, completion: nil)

                }
            })
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            
            // For iPad
            if let popoverController = photoSourceRequestController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                popoverController.sourceView = cell
                popoverController.sourceRect = cell.bounds
                }
            }
            present(photoSourceRequestController, animated: true, completion:nil)
            
        }
    }
  

}
