//
//  RecipeCollectionViewCell.swift
//  DietBalanceApp
//
//  Created by Devika Krishnan on 2022-10-13.
//

import Foundation
import UIKit

//Custom collection cell for healthy recipes in the Healthy Recipe Page
class RecipeCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var healthyRecipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        healthyRecipeImage.layer.cornerRadius = 10
      
    }

}
