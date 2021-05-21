//
//  FeedViewController.swift
//  InstaRecipe
//
//  Created by Vivian Lin on 4/20/21.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    let commentBar = MessageInputBar()
    var showsCommentBar = false
    var selectedPost: PFObject!
    var currentUser: PFUser!
    
    var recipes = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentBar.inputTextView.placeholder = "Add a comment ..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillBeHidden(note: Notification) {
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        //Create the comment
        let comment = PFObject(className:  "Comments" )
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()!

        selectedPost.add(comment, forKey: "comments")

        selectedPost.saveInBackground {
            (success, error) in
            if (success) {
                print("Comment saved")
            } else {
                print("Error saved")
            }
        }
        tableView.reloadData()
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Recipe")
        query.includeKeys(["author", "comments", "comments.author", "likesCount", "likedUsers"])
        query.limit = 20
        
        query.findObjectsInBackground{(recipes, error) in
            if recipes != nil {
                self.recipes = recipes!
                self.tableView.reloadData()
//                PFObject.deleteAll(inBackground: self.recipes) { (success, error) in
//                    if(success) {
//                        print("objects deleted")
//                    }
//                    else {
//                        print("error: \(String(describing: error))")
//                    }
//                }

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
        let recipe = recipes[section]
        let comments = recipe["comments"] as? [PFObject] ?? []
        
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = recipes[indexPath.section]
        let comments = (recipe["comments"] as? [PFObject]) ?? []
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as! RecipeCell
            
            
            let user = recipe["author"] as! PFUser
            
            cell.nameLabel.text = user.username
            cell.descriptionLabel.text = recipe["description"] as? String
            
            // recipe image
            let imageFile = recipe["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.recipeImageView.af.setImage(withURL: url)
            
            let likesCount = recipe["likesCount"]!
            cell.likeLabel.text = "\(likesCount)"
            
            let currentUser = PFUser.current()
            let userExistsInLikedUsers = checkLikedUsers(recipe: recipe, currentUser: currentUser)
            
            if userExistsInLikedUsers == -1 { // user already liked the recipe
                cell.likeButton.setTitle("Unlike", for: .normal)
            }
            else if userExistsInLikedUsers == 0 { // user hasn't liked the recipe
                cell.likeButton.setTitle("Like", for: .normal)
            }
            
            return cell
            
        } else if (indexPath.row <= comments.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user.username
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Create the comment
       let recipe = recipes[indexPath.section]
        let comments = (recipe["comments"] as? [PFObject]) ?? []
        if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = recipe

        }
    }
    
    func checkLikedUsers(recipe: PFObject!, currentUser: PFUser!) -> Int {
        var likedUsers = [PFObject]()
        likedUsers = recipe["likedUsers"] as! [PFUser]
        
        for user in likedUsers {
            let thisUser = user as! PFUser
            let userEmail = "\(String(describing: thisUser.email))"
            let currentUserEmail = "\(String(describing: currentUser.email))"
            if userEmail == currentUserEmail {
                return -1 // user already liked the recipe
            }
        }
        
        return 0 // user hasn't liked the recipe yet
    }
    
    func updateLikeCount(id: String, val: Int) {
        let query = PFQuery(className: "Recipe")
        query.getObjectInBackground(withId: id) { (newRecipe: PFObject?, error: Error?)  in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let newRecipe = newRecipe {
                newRecipe["likesCount"] = val
                newRecipe.saveInBackground()
            }
        }
    }
    
    func updateLikedUser(id: String, user: PFUser!, add: Int, index: Int) {
        let query = PFQuery(className: "Recipe")
        query.getObjectInBackground(withId: id) { (newRecipe: PFObject?, error: Error?)  in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let newRecipe = newRecipe {
                var users = [PFObject]()
                users = newRecipe["likedUsers"] as! [PFObject]
                if add == 1 {
                    users.append(user)
                }
                else if add == 0 {
                    users.remove(at: index)
                }
                newRecipe["likedUsers"] = users;
                newRecipe.saveInBackground()
            }
        }
    }
    
    @IBAction func onLike(_ sender: UIButton) {
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
        let recipe = recipes[indexPath.section] // recipe that was liked
        
        
        let recipeCell = cell as? RecipeCell
        let likeText = recipeCell!.likeButton.titleLabel!.text
        var likeCount = Int(recipeCell!.likeLabel.text!)
        if likeText == "Like" {
            likeCount = likeCount! + 1
            recipeCell!.likeButton.setTitle("Unlike", for: .normal)
            
            // increment like count in parse db
            updateLikeCount(id: recipe.objectId!, val: likeCount!)
//
//            // add current user to liked users
            currentUser = PFUser.current()
            updateLikedUser(id: recipe.objectId!, user: currentUser, add: 1, index: indexPath.row)
            
        }
        else if likeText == "Unlike" {
            likeCount = likeCount! - 1
            recipeCell!.likeButton.setTitle("Like", for: .normal)
            // decrement like count in parse db
            updateLikeCount(id: recipe.objectId!, val: likeCount!)

            //remove current user from liked users
            currentUser = PFUser.current()
            updateLikedUser(id: recipe.objectId!, user: currentUser, add: 0, index: indexPath.row)
        }
        recipeCell!.likeLabel.text = String(likeCount!)
        
    }
    
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
        let recipe = recipes[indexPath.section]

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
