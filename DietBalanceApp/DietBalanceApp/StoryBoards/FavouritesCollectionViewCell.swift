//
//  FavouritesCollectionViewCell.swift
//  DietBalanceApp
//
//  Created by Devika Krishnan on 2022-11-02.
//

import UIKit


//Custom collection cell for Favourited recipe collection for the UserFavoriteRecipeViewController
class FavouritesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        recipeImageView.layer.cornerRadius = 10
 
    
    }
}
