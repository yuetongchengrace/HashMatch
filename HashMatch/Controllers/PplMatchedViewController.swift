//
//  PplMatchedViewController.swift
//  HashMatch
//
//  Created by Ashley Lin on 12/8/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class PplMatchedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var pplMatchedTableView: UITableView!
    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        people = []
//        images = []
//        fetchDataForTableView()
//        setupTableView()
//    }
    override func viewWillAppear(_ animated: Bool) {
        people = []
        images = []
        fetchDataForTableView()
        setupTableView()
    }
    var userId = ""
    var matches : [String] = []
    var people: [Person] = []
    var images: [UIImage] = []
    
    struct Info: Codable{
        var name: String
        var description: String
        var image_url: String
    }
    
    func tableView(_ pplMatchedTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(people.count)
        return people.count
    }
        
    func tableView(_ pplMatchedTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "PplMatchedTableViewCell")
        let profileUIView = UIView(frame: cell.bounds)
        
        let cgrect1 = CGRect.init(x: 15, y: 9, width: 50, height: 50)
        let profilePicture = UIImageView.init(frame: cgrect1)
        profilePicture.image = images[indexPath.row]
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.layer.backgroundColor = UIColor.black.cgColor
        profilePicture.clipsToBounds = true
        
        let cgrect2 = CGRect.init(x: 80, y: 13, width: 270, height: 20)
        let fullName = UILabel.init(frame: cgrect2)
        fullName.text = "\(people[indexPath.row].firstName ) \(people[indexPath.row].lastName ), \(people[indexPath.row].age)"
        //fullName.text = Person.firstName
        fullName.font = UIFont(name: "Gill Sans", size: 18)
        fullName.font = UIFont.boldSystemFont(ofSize: fullName.font.pointSize)
        
        let cgrect3 = CGRect.init(x: 80, y: 45, width: 270, height: 20)
        let personDetails = UILabel.init(frame: cgrect3)
        // theData[indexPath.row].name
        personDetails.text = "\(people[indexPath.row].email )"
        personDetails.font = UIFont(name: "Gill Sans", size: 14)
        
        profileUIView.addSubview(profilePicture)
        profileUIView.addSubview(fullName)
        profileUIView.addSubview(personDetails)
        
        cell.contentView.addSubview(profileUIView)

        return cell
    }
    
    func setupTableView(){
        pplMatchedTableView.dataSource = self
        pplMatchedTableView.delegate = self
        pplMatchedTableView.register(UITableViewCell.self, forCellReuseIdentifier: "PplMatchedTableViewCell")
    }

    func fetchDataForTableView(){
        if let id = UserDefaults.standard.string(forKey: "user"){
           userId = id
        }
        DatabaseManager.shared.getPersonFromUID(with: userId, completion: { person in
            // print("here", person.matches)
            for match in person.matches{
               let db = Firestore.firestore()
               let docRef = db.collection("users").document(match)
               docRef.getDocument { (document, error) in
                   if let document = document, document.exists {
                    if let data = document.data(){
                        // print(data)
                        let email = document.documentID
                        let firstName = data["firstName"] as? String ?? ""
                        let lastName = data["lastName"] as? String ?? ""
                        let uid = data["uid"] as? String ?? ""
                        let photo = data["photo"] as? String ?? ""
                        let description = data["description"] as? String ?? ""
                        let age = data["age"] as? String ?? ""
                        let city = data["city"] as? String ?? ""
                        let state = data["state"] as? String ?? ""
                        let education = data["education"] as? String ?? ""
                        let fieldOfEngineering = data["fieldOfEngineering"] as? String ?? ""
                        let occupation = data["occupation"] as? String ?? ""
                        let quizScore = data["quizScore"] as? Int ?? 0
                        let gender = data["gender"] as? String ?? ""
                        let preference = data["preference"] as? String ?? ""
                        let likes = data["likes"] as? [String] ?? [""]
                        let matches = data["matches"] as? [String] ?? [""]
                        let newPerson = Person(email: email, firstName: firstName, lastName: lastName, uid: uid, photo: photo, description: description, age: age, city: city, state: state,education: education, fieldOfEngineering: fieldOfEngineering, occupation: occupation, quizScore: quizScore, gender: gender, preference: preference, likes: likes, matches: matches)
                        //print(uid)
                        //print(photo)
                        self.people.append(newPerson)
                        // print(newPerson)
                        // print(self.people)
                        self.pplMatchedTableView.reloadData()
                        self.cacheImages(person: newPerson)
                    }
                   } else {
                       print("Document does not exist")
                   }
               }
           }
       })
    
    }

    func cacheImages(person: Person){
        print("how many people?", people.count)
        if let fullURL =  URL(string: person.photo){
            // print(fullURL!)
            do{
                let data = try Data(contentsOf: fullURL)
                let img = UIImage(data:data)
                // print(index)
                images.append(img!)
            }
            catch {
                print("There was an error")
            }
        }
//        for (index, person) in people.enumerated() {
//           if let fullURL =  URL(string: person.photo){
//              // print(fullURL!)
//              do{
//                  let data = try Data(contentsOf: fullURL)
//                  let img = UIImage(data:data)
//                  // print(index)
//                  images[index] = img!
//              }
//              catch {
//                  print("There was an error")
//              }
//           }
//       }
    }
}
