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

class OnboardingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var sexuality: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var education: UITextField!
    @IBOutlet weak var fieldOfEngineering: UITextField!
    @IBOutlet weak var occupation: UITextField!
    
    var email: String = ""
    
    var selectedGender = ""
    var genderOptions = ["-Choose Gender-", "Male", "Female", "Other"]
    var selectedSexuality = ""
    var sexualityOptions = ["-Choose Preference-", "Men", "Women", "Everyone"]
    var selectedState = ""
    var stateOptions = ["-Choose State-", "AK", "AL", "AR", "AS", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "GA", "GU", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MI", "MN", "MO", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VI", "VT", "WA", "WI", "WV", "WY"]
    let pickerView1 = UIPickerView()
    let pickerView2 = UIPickerView()
    let pickerView3 = UIPickerView()
    
    //For gender and sexuality, maybe we should provide options for them to pick from?
    //I didn't add outlet for those two yet
    
    @IBOutlet weak var nextBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient = createGradient()
        self.view.layer.insertSublayer(gradient, at: 0)
        //hide navigation bar so that the user cannot click back to the signup page
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
        nextBtn.applyPrimaryBtnDesign()
        createPickerView()
        dismissPickerView()
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
            let myAge = age.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let myCity = city.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let myState = state.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let edu = education.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let field = fieldOfEngineering.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let occu = occupation.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let gen = gender.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pref = sexuality.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            DatabaseManager.shared.insertPerson(with: Person(email: email, firstName: fName, lastName: lName, uid: UserDefaults.standard.string(forKey: "user")!, photo: "", description: "", age: myAge, city: myCity, state: myState, education: edu, fieldOfEngineering: field, occupation: occu, quizScore: 0, gender: gen, preference: pref, likes: [String](), matches: [String]()))
        
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
    
    //pickerView stuff
    //I CAN STILL TYPE THINGS INTO THE TEXTFIELD...MAYBE OKAY? IF INPUTVIEW IS SET I DONT THINK KEYBOARD APPEARS FOR USERS ON MOBILE?? which is what actually matters
    func createPickerView() {
        pickerView1.delegate = self
        gender.inputView = pickerView1
        pickerView2.delegate = self
        sexuality.inputView = pickerView2
        pickerView3.delegate = self
        state.inputView = pickerView3
    }
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        gender.inputAccessoryView = toolBar
        sexuality.inputAccessoryView = toolBar
        state.inputAccessoryView = toolBar
    }
    @objc func action() {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerView3 {
            return stateOptions.count
        }
        return genderOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerView1 {
            return genderOptions[row]
        }
        if pickerView == pickerView2 {
            return sexualityOptions[row]
        }
        return stateOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerView1 {
            selectedGender = genderOptions[row] // selected item
            gender.text = selectedGender
        }
        else if pickerView == pickerView2 {
            selectedSexuality = sexualityOptions[row] // selected item
            sexuality.text = selectedSexuality
        }
        else {
            selectedState = stateOptions[row] // selected item
            state.text = selectedState
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
