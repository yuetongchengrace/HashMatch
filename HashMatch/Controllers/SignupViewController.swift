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
        self.hideKeyboardWhenTap()
        password.isSecureTextEntry = true
        retypePassword.isSecureTextEntry = true
        continueButton.applyPrimaryBtnDesign()
        
        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func checkInput () -> String?{
        if email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || retypePassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields"
        }
            
        else if(retypePassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) !=  password.text?.trimmingCharacters(in: .whitespacesAndNewlines)){
            return "passwords do not match"
        }
            
        else if let digits = password.text?.trimmingCharacters(in: .whitespacesAndNewlines).count{
            if digits < 6 {
                return "password too short"
            }
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
            
            //transition to the next screen which should be the onboarding questions
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "Onboarding1") as? OnboardingViewController
            secondViewController!.email = self.email.text!
            secondViewController!.password = self.password.text!
            //self.present(secondViewController, animated: true, completion: nil)
            self.navigationController?.pushViewController(secondViewController!, animated: true)
            
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
