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
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        recipeImageView.layer.cornerRadius = 15.0
        super.awakeFromNib()
        // Initialization code
    }
    

    @IBAction func likeRecipe(_ sender: Any) {
        let likeText = likeButton.titleLabel!.text
        var likeCount = Int(likeLabel.text!)
        if likeText == "Like" {
            likeCount = likeCount! + 1
            likeButton.setTitle("Unlike", for: .normal)
        }
        else if likeText == "Unlike" {
            likeCount = likeCount! - 1
            likeButton.setTitle("Like", for: .normal)
        }
        likeLabel.text = String(likeCount!)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
