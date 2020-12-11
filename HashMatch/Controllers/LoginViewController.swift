//
//  LoginViewController.swift
//  HashMatch
//
//  Created by Yuetong Chen on 11/21/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient = createGradient()
        self.view.layer.insertSublayer(gradient, at: 0)

        // Do any additional setup after loading the view.
    }
    func checkInput () -> String?{
       if email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
           return "Please fill in all fields"
       }
       return nil
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let err = checkInput();
           if err != nil{
               errorLabel.text = err!
               errorLabel.alpha = 1
            }
            else{
            Auth.auth().signIn(withEmail: email.text!, password:password.text! ) { (result, error) in
                if error != nil {
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                    
                }
                else{
                    //logged in successfully, save to user default
                    let defaults = UserDefaults.standard
                    if defaults.object(forKey: "isUserSignedIn") == nil{
                         defaults.set(true, forKey: "isUserSignedIn")
                    }
                    if let id = Auth.auth().currentUser?.uid{
                        defaults.set(id ,forKey: "user")
                    }
                    //Go to main collection View
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let secondViewController = storyboard.instantiateViewController(withIdentifier: "Mainpage")
                    // self.present(secondViewController, animated: true, completion: nil)
                    self.navigationController?.pushViewController(secondViewController, animated: true)
                }
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
