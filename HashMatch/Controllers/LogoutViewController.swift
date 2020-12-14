//
//  LogoutViewController.swift
//  HashMatch
//
//  Created by Yuetong Chen on 12/2/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import UIKit
import Firebase
//This is the user setting page
//We can pull user information from the users collection and display on corresponding fields
class LogoutViewController: UIViewController {

    
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var name_age: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var sexualityLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var eduLabel: UILabel!
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var occuLabel: UILabel!
    @IBOutlet weak var descView: UITextView!
    @IBOutlet weak var editDescLabel: UIButton!
    
    
    var userId = ""
    var currentPerson = Person()
    var editingDescription = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.hideKeyboardWhenTap()
        if let id = UserDefaults.standard.string(forKey: "user"){
            userId = id
        }
        let width = view.frame.size.width
        let size = width/3
        profilePicView.frame = CGRect(x: (view.frame.size.width-size)/2, y: 120, width: size, height: size)
        profilePicView.layer.cornerRadius = profilePicView.frame.size.width/2
        profilePicView.image = UIImage(systemName: "person")
        profilePicView.tintColor = .gray
        profilePicView.contentMode = .scaleAspectFit
        profilePicView.layer.masksToBounds = true
        profilePicView.layer.borderWidth = 2
        profilePicView.layer.borderColor = UIColor.lightGray.cgColor
        descView.isEditable = false
        descView.layer.borderColor = UIColor.black.cgColor
        updatePage()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updatePage()
    }
    
    func updatePage() {
        DatabaseManager.shared.getPersonFromUID(with: userId, completion: { person in
            if let fullURL =  URL(string: person.photo){
               do{
                   let data = try Data(contentsOf: fullURL)
                   let img = UIImage(data:data)
                   // print(index)
                self.profilePicView.image = img!
               }
               catch {
                   print("There was an error")
               }
            }
            self.name_age.text = "\(person.firstName) \(person.lastName), \(person.age)"
            self.genderLabel.text = "\(person.gender)"
            self.sexualityLabel.text = "\(person.preference)"
            self.locLabel.text = "\(person.city), \(person.state)"
            self.eduLabel.text = "\(person.education)"
            self.fieldLabel.text = "\(person.fieldOfEngineering)"
            self.occuLabel.text = "\(person.occupation)"
            self.descView.text = "\(person.description)"
                
        })
        profilePicView.setNeedsDisplay()
    }

    override func viewDidDisappear(_ animated: Bool) {
        descView.isEditable = false
        descView.layer.borderWidth = 0
        editDescLabel.setTitle("Edit Description", for: .normal)
    }
    
    @IBAction func retakeQuiz(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let questionViewController1 = storyboard.instantiateViewController(withIdentifier: "Q1")
        // self.present(secondViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(questionViewController1, animated: true)
        
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        // UserDefaults.standard.set(false, forKey: "isUserSignedIn")
        UserDefaults.standard.removeObject(forKey: "isUserSignedIn")
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.removeObject(forKey: "email")
        print(UserDefaults.standard.dictionaryRepresentation())
        navigationController?.popToRootViewController(animated: true)
//        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "baseVC") as UIViewController
//        navigationController?.viewControllers = [rootVC]
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = rootVC
        //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func editDescription(_ sender: Any) {
        if !descView.isEditable {
            descView.isEditable = true
            descView.layer.borderWidth = 1
            editDescLabel.setTitle("Save", for: .normal)
            return

        }
        if descView.isEditable {
            descView.isEditable = false
            descView.layer.borderWidth = 0
            editDescLabel.setTitle("Edit Description", for: .normal)
            
            let db = Firestore.firestore()
            let docRef = db.collection("users").whereField("uid", isEqualTo: userId)
            docRef.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        let email = document.documentID
                        
                        //save desc
                        db.collection("users").document(email).setData(["description": self.descView.text!], merge: true)
                    }
                }
            }
            return
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
