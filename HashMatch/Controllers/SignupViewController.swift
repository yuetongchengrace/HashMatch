//
//  SignupViewController.swift
//  HashMatch
//
//  Created by Yuetong Chen on 11/21/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var retypePassword: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient = createGradient()
        self.view.layer.insertSublayer(gradient, at: 0)
        password.isSecureTextEntry = true
        retypePassword.isSecureTextEntry = true
        continueButton.applyPrimaryBtnDesign()
      
        // Do any additional setup after loading the view.
    }
    
    func checkInput () -> String?{
        if email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || retypePassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields"
        }
        
        if(retypePassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) !=  password.text?.trimmingCharacters(in: .whitespacesAndNewlines)){
            return "passwords do not match"
        }
        
        return nil
        
    }
    @IBAction func signupTapped(_ sender: Any) {
        let err = checkInput();
        if err != nil{
            errorLabel.textColor = .white
            errorLabel.text = err!
            errorLabel.alpha = 1
        }
        else {
            DatabaseManager.shared.userExists(with: email.text!, completion: { [weak self] exists in
            guard let strongSelf = self else {
                return
            }
                
            guard !exists else {
                strongSelf.alertSignUpError(message: "Looks like an account for that email already exists")
                return
            }
            })
            Auth.auth().createUser(withEmail: email.text!, password: password.text! ){
                (result, error) in
                
                //check for errors
                if error != nil{
                    //there was some error
                    self.errorLabel.text = "error while creating user"
                    
                    //TODO: Specify what type of error we encountered:
                    //For example, if password is too short, it should show
                    //something like "password should be at least 6 characters long"
                    
                    
                    self.errorLabel.alpha = 1
                    print(self.email!.text!)
                    print(self.password!.text!)
                }
                else{
                     //signed in successfully, save to user default
                    let defaults = UserDefaults.standard
                    defaults.set(true, forKey: "isUserSignedIn")
                    if let id = Auth.auth().currentUser?.uid{
                        defaults.set(id ,forKey: "user")
                    }
                    //transition to the next screen which should be the onboarding questions
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let secondViewController = storyboard.instantiateViewController(withIdentifier: "Onboarding1") as? OnboardingViewController
                    secondViewController!.email = self.email.text!
                    //self.present(secondViewController, animated: true, completion: nil)
                    self.navigationController?.pushViewController(secondViewController!, animated: true)
                }
            }
        }
    }
    
    func alertSignUpError(message: String = "Please answer all fields.") {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is OnboardingViewController
        {
            let vc = segue.destination as? OnboardingViewController
            vc?.email = email.text!
        }
    }
     */
}
