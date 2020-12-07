//
//  OnboardingViewController.swift
//  HashMatch
//
//  Created by Ashley Lin on 11/22/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var education: UITextField!
    @IBOutlet weak var fieldOfEngineering: UITextField!
    @IBOutlet weak var occupation: UITextField!
    
    var email: String = ""
    
    //For gender and sexuality, maybe we should provide options for them to pick from?
    //I didn't add outlet for those two yet
    
    @IBOutlet weak var nextBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide navigation bar so that the user cannot click back to the signup page
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
        nextBtn.applyPrimaryBtnDesign()
    }
    //Make sure none of the input fields is empty
    func checkInput () -> String?{
        if firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || age.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            city.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            state.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            education.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            fieldOfEngineering.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            occupation.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please fill in all fields"
        }
        return nil
    }
    @IBAction func nextClicked(_ sender: Any) {
        // Check if all user input fields are non-empty and in the correct format
        let err = checkInput();
        if err != nil{
            self.alertSignUpError()
        }
        else{
            
            let fName = firstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lName = lastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let myAge =
                age.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let myCity = city.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let myState = city.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let edu = education.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let field = fieldOfEngineering.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let occu = occupation.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            DatabaseManager.shared.insertUser(with: User(firstName: fName, lastName: lName, emailAddress: email, uid: UserDefaults.standard.string(forKey: "user")!, age: myAge, city: myCity,state: myState, education: edu, fieldOfEngineering: field, occupation: occu, likes: [String](), matches: [String]()))
        
        // *Add to the database / add to local storage first and then put everything into the database
        /*
            let db = Firestore.firestore()
            let fName = firstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lName = lastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            db.collection("users").addDocument(data: [
                "firstName": fName,
                "lastName": lName,
                "uid": UserDefaults.standard.string(forKey: "user")!
                // Continue adding other informations into the database! currently only have first and last name
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                }
            }
            */
        }
        // Push the next page after everything is success (segue is working now?)
    }
    
    func alertSignUpError(message: String = "Please answer all fields.") {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is OnboardingDescribeYourselfVC
        {
            let vc = segue.destination as? OnboardingDescribeYourselfVC
            vc?.email = email
            print("1111: " + vc!.email)
        }
    }
}
extension UIButton{
    func applyPrimaryBtnDesign(){
        self.layer.cornerRadius = 20.0
    }
}
extension UITextView{
    func textViewDesign(){
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
