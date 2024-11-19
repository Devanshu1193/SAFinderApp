//
//  FavouriteViewController.swift
//  SAFinderApp
//
//  Created by Devanshu Suthar on 2024-10-24.
//

import UIKit

class FavouriteViewController: UIViewController {
    
    // MARK: - Properties
    var accommodations: [Accommodation] = [] // Stores the list of favourite accommodations

    var accommodation: Accommodation?
    
    
    // MARK: - Outlets
    @IBOutlet weak var favCollectionView: UICollectionView!
    
    //MARK: - CollectionView DataSource
    // Configures the data source for the collection view using diffable data source
    lazy var collectionViewDataSource = UICollectionViewDiffableDataSource<Section, Accommodation>(collectionView: favCollectionView) { collectionView, indexPath, accommodation in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favCell", for: indexPath) as! FavouriteCollectionViewCell
        
        // Set the image for the accommodation
        if let image = accommodation.image {
            cell.houseImageViewCell.setImage(url: image)
        }
        return cell
    }
    
    // Created a snapshot to populate the collection view
    func createSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Accommodation>()
        snapshot.appendSections([.main]) // Adding a single section
        snapshot.appendItems(App.accommodationStore.allHouses) // Add all favourite houses
        print("houses: \(App.accommodationStore.allHouses.count)")
        
        collectionViewDataSource.apply(snapshot)
    }
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the collection view delegate
        favCollectionView.delegate = self
        
        // Add long press gesture recognizer for removing items
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        favCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.createSnapshot()  // Refresh the snapshot when the view appears
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Pass the selected accommodation to the detail view
        guard let indexPath = favCollectionView.indexPathsForSelectedItems?.first, let accommodation = collectionViewDataSource.itemIdentifier(for: indexPath) else { return }
        
        let destinationVC = segue.destination as? DetailViewController
        destinationVC?.accommodation = accommodation
        destinationVC?.editInfo = true
        
        // Pass the image associated with the accommodation
        destinationVC?.passedImage = App.accommodationStore.fetchImage(withIdentifier: "\(accommodation.id)")
    }
    
    // MARK: - Gestures
    // Long Press Gesture - to remove a house from the list
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer){
        let location = gesture.location(in: favCollectionView)
        
        // Ensure the gesture is at the beginning and a valid index path is found
        guard let indexPath = favCollectionView.indexPathForItem(at: location),
              let accommodation = collectionViewDataSource.itemIdentifier(for: indexPath),
              gesture.state == .began else { return }
        
        // Show an alert to confirm removal
        let alert = UIAlertController(title: "Remove from Favourites?", message: "Do you want to remove \(accommodation.address) from your favourites?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
            
            // Remove the house and save the updated list
            App.accommodationStore.removeHouse(house: accommodation)
            App.accommodationStore.saveHouses()
            self.createSnapshot()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

// MARK: - Extension
extension FavouriteViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    // Set the size for each item in the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20) / 3 // Three items per row, 40 is the total padding
        return CGSize(width: width, height: 125) // Set the hei
    }
    
    // Spacing between items in the same row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // Spacing between rows
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
