//
//  DetailViewController.swift
//  SAFinderApp
//
//  Created by Devanshu Suthar on 2024-10-10.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var houseImageView: UIImageView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var rentTextField: UITextField!
    @IBOutlet weak var contactNumberTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    
    // MARK: - Properties
    var accommodation: Accommodation?
    var accommodationStore: AccommodationStore!
    var passedImage: UIImage?
    var editInfo = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextField.delegate = self
        rentTextField.delegate = self
        contactNumberTextField.delegate = self
        descriptionTextField.delegate = self
        

        if let passedHouse = accommodation{
            addressTextField.text = passedHouse.address
            rentTextField.text = "\(passedHouse.rent)"
            contactNumberTextField.text = "\(passedHouse.phone_number)"
            descriptionTextField.text = "\(passedHouse.description)"
            
            if let image = passedHouse.image {
                houseImageView.setImage(url: image)
            }
            
            houseImageView.image = passedImage
        }
        
        if !editInfo {
            addressTextField.isUserInteractionEnabled = true
            rentTextField.isUserInteractionEnabled = true
            contactNumberTextField.isUserInteractionEnabled = true
            descriptionTextField.isUserInteractionEnabled = true
        }
      
        
    }
    
    // Dismiss keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Extension
extension DetailViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
