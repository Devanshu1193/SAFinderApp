//
//  AccommodationTableViewCell.swift
//  SAFinderApp
//
//  Created by Devanshu Suthar on 2024-09-26.
//

import UIKit

class AccommodationTableViewCell: UITableViewCell{
    
    // MARK: - Outlets
    
    @IBOutlet weak var houseAddress: UILabel!
    @IBOutlet weak var houseRent: UILabel!
    @IBOutlet weak var houseImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        houseImageView.layer.cornerRadius = 10 
        houseImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    
}
