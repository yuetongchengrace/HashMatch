//  CollectionViewController.swift
//  HashMatch
//  Created by Yuetong Chen on 11/23/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.

import UIKit
import Firebase
import FirebaseFirestore

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var userId = ""
    var score = 0
    var gender = ""
    var preference = ""
    var likes: [String] = []
    var matches: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        if let id = UserDefaults.standard.string(forKey: "user"){
            userId = id
        }
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 12
        collectionView!.collectionViewLayout = layout
        //fetch ones own score
        // fetchMyData()
        // fetchData()
        setUpCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        fetchMyData()
    }
    
    var people: [Person] = []
    var images: [Int:UIImage] = [:]
    
    func setUpCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PersonCell.self , forCellWithReuseIdentifier: "cell")
    }
    //get all user data from firestore and saving into the people array
    func fetchMyData(){
        DatabaseManager.shared.getPersonFromUID(with: userId, completion: { person in
            self.score = person.quizScore
            self.gender = person.gender
            self.preference = person.preference
            self.likes = person.likes
            self.matches = person.matches
            self.fetchData()
       })
    }
    func fetchData(){
//        print("my score is:", self.score)
//        print("my gender is:", self.gender)
//        print("my preference is:", self.preference)
//        print("I have liked: ", self.likes)
//        print("I have matched: ", self.matches)
        let db = Firestore.firestore()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                // all key value pairs
                self.people = []
                self.images = [:]
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let email = document.documentID
                    let data = document.data()
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
                    if self.preference == "Everyone" || self.preference == "Women" && gender == "Female" || self.preference == "Men" && gender == "Male"{
//                        print(self.preference)
//                        print(gender)
                        if uid != self.userId && !self.likes.contains(email) && !self.matches.contains(email){
                           let newPerson = Person(email: email, firstName: firstName, lastName: lastName, uid: uid, photo: photo, description: description, age: age, city: city, state: state,education: education, fieldOfEngineering: fieldOfEngineering, occupation: occupation, quizScore: quizScore, gender: gender, preference: preference, likes: likes, matches: matches)
                           //print(uid)
                           //print(photo)
                           self.people.append(newPerson)
                           // print(self.people)
                       }
                    }
                }
                self.orderPeople()
                self.cacheImages()
                self.collectionView.reloadData()
            }
        }
    }
    //function to order people by how close their score is to the current user
    func orderPeople(){
        people = people.sorted(by: {abs($0.quizScore - self.score) < abs($1.quizScore - self.score)})
//        for person in people{
//            print(person.firstName)
//            print(person.quizScore)
//        }
    }
    func cacheImages(){
       for (index, person) in people.enumerated() {
            if let fullURL =  URL(string: person.photo){
               // print(fullURL!)
               do{
                   let data = try Data(contentsOf: fullURL)
                   let img = UIImage(data:data)
                   // print(index)
                   images[index] = img!
               }
               catch {
                   print("There was an error")
               }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.people.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PersonCell
        cell.name.text = "  " + people[indexPath.row].firstName + " " + people[indexPath.row].lastName
        cell.addSubview(cell.pic)
        //cell.addSubview(cell.name)
        
        //cell styling
        cell.backgroundColor = UIColor.gray
        cell.layer.cornerRadius = 20
        cell.heightAnchor.constraint(equalToConstant: 210 ).isActive = true
        cell.widthAnchor.constraint(equalToConstant: 166 ).isActive = true
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        
        //make cell image centered
        let cellPic = cell.pic
        cellPic.translatesAutoresizingMaskIntoConstraints = false
        cellPic.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
        cellPic.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        cellPic.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        cellPic.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        
        //cell image styling
        cellPic.image = images[indexPath.row]
        cellPic.contentMode = .scaleAspectFill
        cellPic.layer.cornerRadius = 20
        cellPic.clipsToBounds = true
        
        //cell text styling
        let cgrect1 = CGRect.init(x: 10, y: 165, width: 146, height: 28)
        let nameLabel = UILabel.init(frame: cgrect1)
        nameLabel.text = people[indexPath.row].firstName + " " + people[indexPath.row].lastName
        cell.addSubview(nameLabel)
        nameLabel.layer.cornerRadius = 14
        nameLabel.layer.backgroundColor = UIColor.white.cgColor
        nameLabel.textColor = UIColor.hashOrange
        //nameLabel.font = nameLabel.font.withSize(10)
        nameLabel.font = UIFont(name: "Gill Sans", size: 15)
        nameLabel.font = UIFont.boldSystemFont(ofSize: nameLabel.font.pointSize)
        nameLabel.textAlignment = NSTextAlignment.center
       
        return cell as PersonCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("touched")
//        let detailedVC = DetailedViewController()
//        detailedVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let secondViewController  = storyboard.instantiateViewController(withIdentifier: "Detailpage") as? DetailedViewController else { return }
        secondViewController.person = people[indexPath.row]
        // self.present(secondViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
}

extension CollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: 166, height: 210)
    }
}
extension UIColor{
    static let hashOrange = UIColor(red: 255.0/255, green: 67.0/255, blue: 60.0/255, alpha: 1.0)
}

//old cell text styling
//        //cell text styling
//        let cellText = cell.name
//        cellText.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
//        cellText.textAlignment = NSTextAlignment.center
//        cellText.layer.borderWidth = 0.5
//        cellText.layer.borderColor = UIColor.black.cgColor
//        cellText.layer.backgroundColor = UIColor.white.cgColor
//        cellText.textColor = UIColor.black

//        //make cell text centered
//        cellText.translatesAutoresizingMaskIntoConstraints = false
//        cellText.heightAnchor.constraint(equalToConstant: 22).isActive = true
//        cellText.widthAnchor.constraint(equalToConstant: 130).isActive = true
//        cellText.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
//        cellText.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
