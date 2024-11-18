//
//  ImageViewController.swift
//  SAFinderApp
//
//  Created by Devanshu Suthar on 2024-11-18.
//

import UIKit

class ImageViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var houseImage: UIImageView!
    
    //MARK: - Properties
    var image: UIImage?
    var accommodation: Accommodation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // Set the image
        houseImage.image = image
        houseImage.contentMode = .scaleAspectFit
        houseImage.isUserInteractionEnabled = true
        
        // Add Pinch Gesture
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        houseImage.addGestureRecognizer(pinchGesture)
        
        // Add Swipe Gesture
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.direction = .down
        houseImage.addGestureRecognizer(swipeGesture)
    }
    
    // MARK: - Gesture Handlers
    @objc func handlePinchGesture(_ sender: UIPinchGestureRecognizer) {
        guard let imageView = sender.view else { return }
        
        imageView.transform = imageView.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1.0 
    }
    
    @objc func handleSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }

}
