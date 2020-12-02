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
            let popup = UIAlertController(title: "Confirm", message: "Make sure you implement all fields", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "Got it!", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
             })
            popup.addAction(ok)
            self.present(popup, animated: true, completion: nil)
            
         }
        else{
            // *Add to the database / add to local storage first and then put everything into the database
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
}
        // Push the next page after everything is success (segue is working now?)
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
