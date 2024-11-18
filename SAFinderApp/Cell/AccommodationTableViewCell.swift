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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
