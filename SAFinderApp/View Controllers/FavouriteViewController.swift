//
//  FavouriteViewController.swift
//  SAFinderApp
//
//  Created by Devanshu Suthar on 2024-10-24.
//

import UIKit

class FavouriteViewController: UIViewController {
    
    // MARK: - Properties
    var accommodations: [Accommodation] = []
    var accommodation: Accommodation?
    
    
    // MARK: - Outlets
    @IBOutlet weak var favCollectionView: UICollectionView!
    
    //MARK: - CollectionView DataSource
    lazy var collectionViewDataSource = UICollectionViewDiffableDataSource<Section, Accommodation>(collectionView: favCollectionView) { collectionView, indexPath, accommodation in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favCell", for: indexPath) as! FavouriteCollectionViewCell
        
        //TODO: Fetch the image for the favourite movie
        if let image = accommodation.image {
            cell.houseImageViewCell.setImage(url: image)
        }
                
        return cell
    }
    
    func createSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Accommodation>()
        snapshot.appendSections([.main])
        snapshot.appendItems(App.accommodationStore.allHouses)
        print("houses: \(App.accommodationStore.allHouses.count)")
        
        collectionViewDataSource.apply(snapshot)
    }
    
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favCollectionView.delegate = self
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        favCollectionView.addGestureRecognizer(longPressGesture)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createSnapshot()
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = favCollectionView.indexPathsForSelectedItems?.first, let accommodation = collectionViewDataSource.itemIdentifier(for: indexPath) else { return }
        
        let destinationVC = segue.destination as? DetailViewController
        
        //TODO: - Pass the appropriate information
        destinationVC?.accommodation = accommodation
        destinationVC?.editInfo = true
        
        destinationVC?.passedImage = App.accommodationStore.fetchImage(withIdentifier: "\(accommodation.id)")
        
    }
    
    // MARK: - Gestures
    // Long Press Gesture - to remove house from the list
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer){
        let location = gesture.location(in: favCollectionView)
        
        guard let indexPath = favCollectionView.indexPathForItem(at: location),
              let accommodation = collectionViewDataSource.itemIdentifier(for: indexPath),
              gesture.state == .began else { return }
        
        let alert = UIAlertController(title: "Remove from Favourites?", message: "Do you want to remove \(accommodation.address) from your favourites?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20) / 3 // Three items per row, 40 is the total padding
        return CGSize(width: width, height: 125) // Set the hei
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // Spacing between items in a row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // Spacing between rows
    }
}
