//
//  FavouriteCollectionViewCell.swift
//  SAFinderApp
//
//  Created by Devanshu Suthar on 2024-10-25.
//

import UIKit

class FavouriteCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var houseImageViewCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        houseImageViewCell.layer.cornerRadius = 10
        houseImageViewCell.clipsToBounds = true
    }

}
