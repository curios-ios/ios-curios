//
//  LoginViewController.swift
//  InstaRecipe
//
//  Created by Vivian Lin on 4/20/21.
//

import UIKit
import Parse
class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var signIn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        signIn.layer.cornerRadius = 15.0
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        self.performSegue(withIdentifier: "createSegue", sender: nil)
        
    }
    @IBAction func onSignIn(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        PFUser.logInWithUsername(inBackground: email, password: password) {
            ( user, error) in
            if (user != nil) {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
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
