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
    var userId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
        if let id = UserDefaults.standard.string(forKey: "user"){
            userId = id
        }
        fetchData()
        setUpCollectionView()
    }
    
    var people: [Person] = []
    var images: [Int:UIImage] = [:]
    
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
                    let uid = data["uid"] as? String ?? ""
                    let photo = data["photo"] as? String ?? ""
                    if uid != self.userId{
                        let newPerson = Person(firstName: firstName, lastName: lastName, uid: uid, photo: photo)
                        //print(uid)
                        //print(photo)
                        self.people.append(newPerson)
                        // print(self.people)
                    }
                }
                self.cacheImages()
                self.collectionView.reloadData()
            }
        }
    }
    func cacheImages(){
       for (index, person) in people.enumerated() {
           let fullURL =  URL(string: person.photo)
               // print(fullURL!)
               do{
                   let data = try Data(contentsOf: fullURL!)
                   let img = UIImage(data:data)
                   // print(index)
                   images[index] = img!
                   
               }
               catch {
                   print("There was an error")
               }
           }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.people.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PersonCell
        cell.backgroundColor = UIColor.gray
        cell.pic.image = images[indexPath.row]
        cell.name.text = people[indexPath.row].firstName + " " + people[indexPath.row].lastName
        cell.addSubview(cell.pic)
        cell.addSubview(cell.name)
        return cell as PersonCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("touched")
//        let detailedVC = DetailedViewController()
//        detailedVC
//
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let secondViewController  = storyboard.instantiateViewController(withIdentifier: "Detailpage") as? DetailedViewController else { return }
        secondViewController.person = people[indexPath.row]
        // self.present(secondViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
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
