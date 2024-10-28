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
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    
    // MARK: - Properties
    var accommodation: Accommodation?
    var passedImage: UIImage?
    var editInfo = true
    
    // MARK: - Actions
    @IBAction func saveChanges(_ sender: UIButton) {
        
    }
    
    
    @IBAction func addToFavourites(_ sender: UIBarButtonItem) {
        guard let passedHouse = accommodation else { return }
        
        //TODO: - Save Changes and update it to your API data
        if App.accommodationStore.alreadyInList(house: passedHouse){
            App.accommodationStore.removeHouse(house: passedHouse)
            
            showAlert(withMessage: "\(passedHouse.address) has been removed from your favourites.", andTitle: "Removed from favourites.")
            favouriteButton.image = UIImage(systemName: "heart")
        } else {
            App.accommodationStore.addNewHouse(house: passedHouse)
            favouriteButton.image = UIImage(systemName: "heart.fill")
        }
        
        App.accommodationStore.saveHouses()
        
    }
    
    
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
            
            if App.accommodationStore.alreadyInList(house: passedHouse){
                favouriteButton.image = UIImage(systemName: "heart.fill")
            } else {
                favouriteButton.image = UIImage(systemName: "heart")
            }
            
            houseImageView.image = passedImage
        }
        
        if !editInfo {
            addressTextField.isUserInteractionEnabled = true
            rentTextField.isUserInteractionEnabled = true
            contactNumberTextField.isUserInteractionEnabled = true
            descriptionTextField.isUserInteractionEnabled = true
//            saveChangesButton.isEnabled = false
            saveChangesButton.isHidden = true
        }
      
        
        
    }
    
    // MARK: - Show an alert if house is added or removed
    func showAlert(withMessage message: String, andTitle title: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default){
            _ in
            self.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
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
