//
//  EditViewController.swift
//  HashMatch
//
//  Created by Jaeyoung Martin on 12/12/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class EditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var sexuality: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var education: UITextField!
    @IBOutlet weak var FOE: UITextField!
    @IBOutlet weak var occu: UITextField!
    
    var userId = ""
    var selectedGender = ""
    var genderOptions = ["Male", "Female", "Other"]
    var selectedSexuality = ""
    var sexualityOptions = ["Men", "Women", "Everyone"]
    var selectedState = ""
    var stateOptions = [ "AK", "AL", "AR", "AS", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "GA", "GU", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MI", "MN", "MO", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VI", "VT", "WA", "WI", "WV", "WY"]
    let pickerView1 = UIPickerView()
    let pickerView2 = UIPickerView()
    let pickerView3 = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = UserDefaults.standard.string(forKey: "user"){
            userId = id
        }
        updatePage()
        let width = view.frame.size.width
        let size = width/3
        profilePic.frame = CGRect(x: (view.frame.size.width-size)/2, y: 120, width: size, height: size)
        profilePic.layer.cornerRadius = profilePic.frame.size.width/2
        profilePic.image = UIImage(systemName: "person")
        profilePic.tintColor = .gray
        profilePic.contentMode = .scaleAspectFit
        profilePic.layer.masksToBounds = true
        profilePic.layer.borderWidth = 2
        profilePic.layer.borderColor = UIColor.lightGray.cgColor
        profilePic.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(changeProfilePic))
        gesture.numberOfTouchesRequired = 1
        profilePic.addGestureRecognizer(gesture)
        
        createPickerView()
        dismissPickerView()
    }
    
    @objc private func changeProfilePic() {
        presentPhotoActionSheet()
    }
    
    func updatePage() {
        DatabaseManager.shared.getPersonFromUID(with: userId, completion: { person in
            if let fullURL =  URL(string: person.photo){
               do{
                   let data = try Data(contentsOf: fullURL)
                   let img = UIImage(data:data)
                   // print(index)
                self.profilePic.image = img!
               }
               catch {
                   print("There was an error")
               }
            }
            self.firstName.text = person.firstName
            self.lastName.text = person.lastName
            self.age.text = person.age
            self.gender.text = person.gender
            self.sexuality.text = person.preference
            self.city.text = person.city
            self.state.text = person.state
            self.education.text = person.education
            self.FOE.text = person.fieldOfEngineering
            self.occu.text = person.occupation
                
        })
    }
    
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
    
    @IBAction func savePressed(_ sender: Any) {
        let fName = firstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lName = lastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let myAge = age.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let myCity = city.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let myState = state.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let edu = education.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let field = FOE.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let occupation = occu.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let gen = gender.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let pref = sexuality.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let image = profilePic.image,
            let data = image.pngData() else {
                return
        }
                
        let db = Firestore.firestore()
        let docRef = db.collection("users").whereField("uid", isEqualTo: userId)
        docRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let email = document.documentID
                    let fileName = "\(email).png"
                    
                    //save fields
                    db.collection("users").document(email).setData(["firstName": fName, "lastName": lName, "age": myAge, "city": myCity, "state": myState, "education": edu, "fieldOfEngineering": field, "gender": gen, "preference": pref, "occupation": occupation], merge: true)
                    //replace prev image in storage with current
                    StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: { result in
                        switch result {
                        case .success:
                            print("image saved")
                            _ = self.navigationController?.popViewController(animated: true)
                            return
                        case .failure(let error):
                            print("Storage manager error: \(error)")
                        }
                    })
                    
                }
            }
        }
        
    }
    
}

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {[weak self]_ in self?.presentCamera()}))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {[weak self]_ in self?.presentPhotoPicker()}))
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.profilePic.image = image
    }
}
