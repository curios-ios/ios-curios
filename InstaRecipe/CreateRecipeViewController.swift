//
//  CreateRecipeViewController.swift
//  InstaRecipe
//
//  Created by Lawrence Lin on 4/22/21.
//

import UIKit
import Parse
import AlamofireImage

class CreateRecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var selectedRecipe: PFObject!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var ingredientsView: UITextView!
    @IBOutlet weak var recipeTextView: UITextView!

    var isForked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(selectedRecipe != nil){
            populateFields()
        }
   
    }
    
    func populateFields(){
        isForked = true
        nameField.text = selectedRecipe["name"] as? String
        imageView.image = selectedRecipe["image"] as? UIImage
        ingredientsView.text = selectedRecipe["ingredients"] as? String
        descriptionView.text = selectedRecipe["description"] as? String
        
        if let image = selectedRecipe["image"] as? PFFileObject {
            image.getDataInBackground({ (imageData, error) in
                if(error == nil){
                    self.imageView.image = UIImage(data: imageData!)
                }
            })
        }
    }
    
    @IBAction func onSubmitButton(_ sender: Any) {
        let recipe = PFObject(className: "Recipe")
        
        recipe["name"] = nameField.text!
        recipe["author"] = PFUser.current()!
        recipe["ingredients"] = ingredientsView.text!
        recipe["description"] = descriptionView.text!
        recipe["isForked"] = isForked
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        recipe["image"] = file
        
        recipe.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("Saved!")
            } else {
                print("Error!")
            }
        }
        
        
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageAspectScaled(toFill: size)
        
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
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
