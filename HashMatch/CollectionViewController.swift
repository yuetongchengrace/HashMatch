//
//  CollectionViewController.swift
//  HashMatch
//
//  Created by Yuetong Chen on 11/23/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
        if let uid = UserDefaults.standard.string(forKey: "user") {
            print(uid)
            //this is the current user's UID
        }
        fetchData()
        setUpCollectionView()
    }
    
    var people: [Person] = []
    func setUpCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PersonCell.self , forCellWithReuseIdentifier: "cell")
    }
    //get all user data from firestore and saving into the people array
    func fetchData(){
        let db = Firestore.firestore()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                // all key value pairs
                for document in querySnapshot!.documents {
                    
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    let firstName = data["firstName"] as? String ?? ""
                    let lastName = data["lastName"] as? String ?? ""
                    let id = document.documentID
                    let newPerson = Person(firstName: firstName, lastName: lastName, id: id)
                    // print(newPerson)
                    self.people.append(newPerson)
                    // print(self.people)
                }
                self.collectionView.reloadData()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.people.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PersonCell
        cell.backgroundColor = UIColor.gray
        cell.name.text = people[indexPath.row].firstName + " " + people[indexPath.row].lastName
        cell.addSubview(cell.pic)
        cell.addSubview(cell.name)
        return cell as PersonCell
        
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

extension CollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: 150, height: 200)
    }
}
