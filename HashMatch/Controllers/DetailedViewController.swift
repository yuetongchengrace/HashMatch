//
//  DetailedViewController.swift
//  HashMatch
//
//  Created by Yuetong Chen on 12/5/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class DetailedViewController: UIViewController {
    var person = Person()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name_ageLabel: UILabel!
    @IBOutlet weak var gender_occuLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var eduLabel: UILabel!
    @IBOutlet weak var fieldLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        guard let p = person as Person? else { return }
        
        let width = view.frame.size.width
        let size = width/1.8
        imageView.frame = CGRect(x: (view.frame.size.width-size)/2, y: 120, width: size, height: size)
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
     
        //add Image
        let url = URL(string: p.photo)
        if url != nil{
            if let img = try? Data(contentsOf: url!){
               imageView.image = UIImage(data:img)
            }
        }

        
        name_ageLabel.text = "\(person.firstName) \(person.lastName), \(person.age)"
        gender_occuLabel.text = "\(person.gender), \(person.occupation)"
        locLabel.text = "\(person.city), \(person.state)"
        eduLabel.text = "\(person.education)"
        fieldLabel.text = "\(person.fieldOfEngineering)"
        descriptionLabel.text = "\(person.description)"
        descriptionLabel.layer.borderColor = UIColor.darkGray.cgColor
        descriptionLabel.layer.borderWidth = 3.0
        descriptionLabel.layer.cornerRadius = 8
    }
    
    @IBAction func likePressed(_ sender: Any) {
        let db = Firestore.firestore()
        let id = UserDefaults.standard.string(forKey: "user")
        let docRef = db.collection("users").whereField("uid", isEqualTo: id!)
        docRef.getDocuments { (querySnapshot, error) in
            for document in querySnapshot!.documents {
                let email = document.reference.documentID
                let myLikes = document.data()["likes"] as? [String] ?? []
                let myMatches = document.data()["matches"] as? [String] ?? []
                print(myLikes)
                print(myMatches)
                let theirMatches = self.person.matches
                let theirLikes = self.person.likes
                let userRef = db.collection("users").document(email)
                let themRef = db.collection("users").document(self.person.email)
                
                //you are already matched
                if theirMatches.contains(email){
                    self.alert(title: "Wait", message: "You are already matched")
                }
                //You have liked them and they haven't liked u back
                else if myLikes.contains(self.person.email){
                     self.alert(title: "Wait", message: "You have already liked them")
                }
                //its a match
                else if theirLikes.contains(email) {
                    //add them to your matches
                    userRef.updateData([
                        "matches": FieldValue.arrayUnion([self.person.email])
                    ])
                    //add yourself to their matches
                    themRef.updateData([
                        "matches": FieldValue.arrayUnion([email])
                    ])
                    //remove yourself from their likes
                    themRef.updateData([
                        "likes": FieldValue.arrayRemove([email])
                    ])
                    
                    print("It's a Match!")
                    self.alert(title: "Congrats", message: "Wow it was a match!")
                    //do something
                    
                } else {
                    //not a match -> they haven't liked you
                    userRef.updateData([
                        "likes": FieldValue.arrayUnion([self.person.email])
                    ])
                    self.alert(title: "Liked", message: "You have successfully liked them")
                }
            }
        }
    }
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
