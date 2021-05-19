//
//  FeedViewController.swift
//  InstaRecipe
//
//  Created by Vivian Lin on 4/20/21.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var recipes = [PFObject]()
    var selectedPost: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Recipe")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground{(recipes, error) in
            if recipes != nil {
                self.recipes = recipes!
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let
           delegate = windowScene.delegate as? SceneDelegate else { return }
        
        delegate.window?.rootViewController = loginViewController
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as! RecipeCell
        
        let recipe = recipes[indexPath.row]
        let user = recipe["author"] as! PFUser
        
        cell.nameLabel.text = user.username
        cell.descriptionLabel.text = recipe["description"] as? String
        
        // recipe image
        let imageFile = recipe["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.recipeImageView.af.setImage(withURL: url)
        
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let post = recipes[indexPath.section]
//        let comments = (post["comments"] as? [PFObject]) ?? []
//
//
//        if indexPath.row == comments.count + 1 {
//            showsCommentBar = true
//            becomeFirstResponder()
//            commentBar.inputTextView.becomeFirstResponder()
//
//            selectedPost = post
//        }
//
//    }
    
    @IBAction func onFork(_ sender: UIButton) {
        var superview = sender.superview
        while let view = superview, !(view is UITableViewCell) {
            superview = view.superview
        }
        guard let cell = superview as? UITableViewCell else {
            print("button is not contained in a table view cell")
            return
        }
        guard let indexPath = tableView.indexPath(for: cell) else {
            print("failed to get index path for cell containing button")
            return
        }
        let recipe = recipes[indexPath.row]
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let createRecipeViewController = main.instantiateViewController(withIdentifier: "CreateRecipeViewController") as! CreateRecipeViewController
    
        createRecipeViewController.selectedRecipe = recipe
        self.present(createRecipeViewController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
