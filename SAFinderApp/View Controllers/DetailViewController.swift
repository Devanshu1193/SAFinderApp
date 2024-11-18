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
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    var accommodation: Accommodation?
    var passedImage: UIImage?
    var editInfo = false
    
    // MARK: - Actions
    @IBAction func saveChanges(_ sender: UIButton) {
        guard let accommodation = accommodation else { return }
        
        guard let rent = Double(rentTextField.text ?? "0") else {
            return
        }
        
        App.accommodationStore.removeHouse(house: accommodation)
        
        let newAccommodation = Accommodation(
            id: accommodation.id,
            image: accommodation.image,
            address: addressTextField.text ?? "",
            rent: rent,
            phone_number: contactNumberTextField.text ?? "",
            description: descriptionTextField.text ?? ""
        )
        
        App.accommodationStore.addNewHouse(house: newAccommodation)
        App.accommodationStore.saveHouses()
        
        navigationController?.popViewController(animated: true)
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
            showAlert(withMessage: "\(passedHouse.address) has been added to your favourites.", andTitle: "Added to favourites.")
            favouriteButton.image = UIImage(systemName: "heart.fill")
        }
        
        App.accommodationStore.saveHouses()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextField.layer.cornerRadius = 8
        descriptionTextField.layer.borderWidth = 1
        descriptionTextField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        
        addressTextField.delegate = self
        rentTextField.delegate = self
        contactNumberTextField.delegate = self
        descriptionTextField.isScrollEnabled = true

        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        bar.items = [done]
        bar.sizeToFit()
        descriptionTextField.inputAccessoryView = bar
        
        if let apiAccomodation = accommodation{
            
            let stored = App.accommodationStore.allHouses.first {
                $0.id == apiAccomodation.id
            }
            
            let passedHouse = apiAccomodation
            
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
            addressTextField.isUserInteractionEnabled = false
            rentTextField.isUserInteractionEnabled = false
            contactNumberTextField.isUserInteractionEnabled = false
            descriptionTextField.isUserInteractionEnabled = false
            saveChangesButton.isHidden = true
        }
      
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjuctForKeyword), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjuctForKeyword), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        dismissKeyboard()
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
    
    @objc func adjuctForKeyword(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenFrame = keyboardValue.cgRectValue
        let keyboardViewFrame = view.convert(keyboardScreenFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification{
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewFrame.height - view.safeAreaInsets.bottom , right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
}

// MARK: - Extension
extension DetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
