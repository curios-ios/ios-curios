//
//  RecipeCell.swift
//  InstaRecipe
//
//  Created by Md Sadiq Sada on 4/28/21.
//

import UIKit

class RecipeCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    override func awakeFromNib() {
        recipeImageView.layer.cornerRadius = 15.0
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
