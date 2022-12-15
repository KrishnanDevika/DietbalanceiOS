//
//  RecipeTableViewCell.swift
//  DietBalanceApp
//
//  Created by Devika Krishnan on 2022-10-05.
//

import Foundation
import UIKit


// Custom table view cell for Search Recipe page
class RecipeTableViewCell : UITableViewCell{
    
    //MARK: - Outlets
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    
    
    //MARK: - view Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        recipeImage.layer.cornerRadius = 50
        recipeImage.clipsToBounds = true
        recipeImage.layer.borderColor = UIColor.black.cgColor
        recipeImage.layer.borderWidth = 2
        cardView.layer.cornerRadius = 10
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
