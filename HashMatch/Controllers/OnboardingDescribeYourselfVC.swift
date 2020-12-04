//
//  OnboardingDescribeYourselfVC.swift
//  HashMatch
//
//  Created by Ashley Lin on 11/23/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import UIKit

class OnboardingDescribeYourselfVC: UIViewController {

    @IBOutlet weak var nextbtn: UIButton!
    @IBOutlet weak var describeYourselfTextView: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
  
    var email: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        describeYourselfTextView.textViewDesign()
        nextbtn.applyPrimaryBtnDesign()
        
        //setup initial imageView, idk how to do it in storyboard
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.isUserInteractionEnabled = true
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(changeProfilePic))
        gesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(gesture)
    }
    
    @objc private func changeProfilePic() {
        presentPhotoActionSheet()
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        uploadPicture()
    }
    
    func checkInput () -> String?{
       if describeYourselfTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
           return "Please fill in all fields"
       }
       return nil
    }
    
    func uploadPicture() {
        let err = checkInput ()
        if err != nil{
            self.alertError()
        }
        else{
            guard let image = imageView.image,
                let data = image.pngData() else {
                    return
            }
            let filename = "\(email)_profpic.png"
            StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
                switch result {
                case .success(let downloadUrl):
                    UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                    print(downloadUrl)
                    DatabaseManager.shared.insertPhoto(with: self.email, url: downloadUrl, description: self.describeYourselfTextView.text!)
                case .failure(let error):
                    print("Storage manager error: \(error)")
                }
            })
            
        }
    }
    func alertError(message: String = "Please answer all fields.") {
       let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
       present(alert, animated: true)
    }
    
}

extension OnboardingDescribeYourselfVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        self.imageView.image = image
    }
}
