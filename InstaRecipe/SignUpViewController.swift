//
//  SignUpViewController.swift
//  InstaRecipe
//
//  Created by Vivian Lin on 4/20/21.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

  
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBAction func backToSignUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        createAccountButton.layer.cornerRadius = 15.0
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        // Do any additional setup after loading the view.
    }

    @IBAction func onSignUp(_ sender: Any) {
        var user = PFUser()
        user.username = nameTextField.text
        user.email = emailTextField.text
        user.password = passwordTextField.text
        // other fields can be set just like with PFObject
        user.signUpInBackground {(success, error) in
            if success {
                self.performSegue(withIdentifier: "signUpSegue", sender: nil)
            } else {
                print("Error: \(error?.localizedDescription)")
                
            }
        }
  
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
