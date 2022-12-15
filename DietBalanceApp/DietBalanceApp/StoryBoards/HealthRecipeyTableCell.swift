//
//  HealthRecipeyTableCell.swift
//  DietBalanceApp
//
//  Created by Devika Krishnan on 2022-11-10.
//

import Foundation
import UIKit



//Custom Table view cell for Favourites Healthy recipe page
class HealthRecipeyTableCell : UITableViewCell{
    
    //MARK: - Outlets
    @IBOutlet weak var healthyrecipeCalories: UILabel!
    @IBOutlet weak var healthyRecipeName: UILabel!
    @IBOutlet weak var healthyImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        healthyImageView.layer.cornerRadius = 50
        healthyImageView.clipsToBounds = true
        healthyImageView.layer.borderColor = UIColor.black.cgColor
        healthyImageView.layer.borderWidth = 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
