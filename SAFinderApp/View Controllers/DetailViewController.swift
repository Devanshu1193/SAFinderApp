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
    var accommodation: Accommodation? // Stores accommodation details passed from the previous view
    var passedImage: UIImage?  // Stores the image of the accommodation
    var editInfo = false
    
    // MARK: - Actions
    // Action to save changes made to the accommodation details
    @IBAction func saveChanges(_ sender: UIButton) {
        guard let accommodation = accommodation else { return }
        
        // Ensure rent is a valid number
        guard let rent = Double(rentTextField.text ?? "0") else {
            return
        }
        
        // Remove the existing accommodation and replace it with updated details
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
        showAlert(withMessage: "Changes have been saved!", andTitle: "Changes Saved")
        navigationController?.popViewController(animated: true)
    }
    
    // Action to add or remove the accommodation from the favourites list
    @IBAction func addToFavourites(_ sender: UIBarButtonItem) {
        guard let passedHouse = accommodation else { return }
        
        // Check if the accommodation is already in favourites
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
    
    // MARK: - View Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure description text field with a border and rounded corners
        descriptionTextField.layer.cornerRadius = 8
        descriptionTextField.layer.borderWidth = 1
        descriptionTextField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        
        // Set text field delegates
        addressTextField.delegate = self
        rentTextField.delegate = self
        contactNumberTextField.delegate = self

        // Add a toolbar with a "Done" button to dismiss the keyboard
        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        bar.items = [done]
        bar.sizeToFit()
        
        // Populate the UI with the passed accommodation data
        if let apiAccomodation = accommodation{
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
        
        // Disable editing if `editInfo` is false
        if !editInfo {
            addressTextField.isUserInteractionEnabled = false
            rentTextField.isUserInteractionEnabled = false
            contactNumberTextField.isUserInteractionEnabled = false
            descriptionTextField.isEditable = false
            saveChangesButton.isHidden = true
        } else {
            descriptionTextField.inputAccessoryView = bar
            rentTextField.inputAccessoryView = bar
            contactNumberTextField.inputAccessoryView = bar
        }
      
        // Register keyboard notifications for adjusting scroll view
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjuctForKeyword), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjuctForKeyword), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        dismissKeyboard()
        
        // Double Tap Gesture - to see image
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        houseImageView.isUserInteractionEnabled = true
        houseImageView.addGestureRecognizer(doubleTapGesture)
    }
    
    // MARK: - Segue
    // Prepare for transitioning to the ImageViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ImageViewController {
            destination.image = passedImage
        }
    }
    
    // MARK: - Alert Func
    // Show an alert if house is added or removed.
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
    
    // Adjust the scroll view for the keyboard
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
    
    // MARK: - Double-tap Gesture
    // Handle double-tap gesture to view the image in full screen
    @objc func handleDoubleTap(){
        guard let image = houseImageView.image else {
            print("No image to pass")
            return
        }
        passedImage = image
        performSegue(withIdentifier: "viewImage", sender: nil)
    }
}

// MARK: - Extension
extension DetailViewController: UITextFieldDelegate {
    
    // Handle return key press on the keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
