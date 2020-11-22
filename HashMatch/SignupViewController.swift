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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func checkInput () -> String?{
        if email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || retypePassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields"
        }
        return nil
    }
    @IBAction func signupTapped(_ sender: Any) {
        let err = checkInput();
        if err != nil{
            errorLabel.text = err!
            errorLabel.alpha = 1
        }
        else{
            Auth.auth().createUser(withEmail: email.text!, password: password.text! ){
                (result, error) in
                
                //check for errors
                if error != nil{
                    //there was some error
                    self.errorLabel.text = "error while creating user"
                    self.errorLabel.alpha = 1
                    print(self.email!.text!)
                    print(self.password!.text!)
                }
            }
            //created user
            //transition to the next screen which should be the onboarding questions
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
