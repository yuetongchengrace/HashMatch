//
//  DatabaseManager.swift
//  HashMatch
//
//  Created by Jaeyoung Martin on 12/3/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import Foundation
import Firebase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let database = Firestore.firestore()

}


extension DatabaseManager {
    
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
        let docRef = database.collection("users").document(email)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                completion(true)
            } else {
                print("Document does not exist")
                completion(false)
            }
        }
    
        return
    }
    
    // Inserts new user to database
    public func insertPerson(with person: Person) {
        database.collection("users").document(person.email).setData(["firstName": person.firstName, "lastName": person.lastName, "uid": person.uid, "age": person.age, "city": person.city, "state": person.state, "education": person.education, "fieldOfEngineering": person.fieldOfEngineering, "occupation": person.occupation, "likes": person.likes, "matches": person.matches])
    }
    //insert photo
    public func insertPhoto(with email: String, url: String, description: String) {
        database.collection("users").document(email).setData(["photo": url, "description": description], merge: true)
    }
    
    public func getPersonFromEmail(with email: String) -> Person {
        var person = Person()
        let docRef = database.collection("users").document(email)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                person = Person(email: document.documentID,
                                firstName: document.get("firstName") as? String ?? "",
                                lastName: document.get("lastName") as? String ?? "",
                                uid: document.get("uid") as? String ?? "",
                                photo: document.get("photo") as? String ?? "",
                                description: document.get("description") as? String ?? "",
                                age: document.get("occupation") as! String,
                                city: document.get("city") as! String,
                                state: document.get("state") as! String,
                                education: document.get("education") as! String,
                                fieldOfEngineering: document.get("fieldOfEngineering") as! String,
                                occupation: document.get("occupation") as! String,
                                likes: document.get("likes") as! [String],
                                matches: document.get("matches") as! [String])
            }
        }
        return person
    }
    
    public func getPersonFromUID(with uid: String, completion: @escaping ((Person) -> Void)) {
        var person = Person()
        let docRef = database.collection("users").whereField("uid", isEqualTo: uid)
        docRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    person.firstName = document.get("firstName") as? String ?? ""
                    person = Person(email: document.documentID,
                    firstName: document.get("firstName") as? String ?? "",
                    lastName: document.get("lastName") as? String ?? "",
                    uid: document.get("uid") as? String ?? "",
                    photo: document.get("photo") as? String ?? "",
                    description: document.get("description") as? String ?? "",
                    age: document.get("age") as! String,
                    city: document.get("city") as! String,
                    state: document.get("state") as! String,
                    education: document.get("education") as! String,
                    fieldOfEngineering: document.get("fieldOfEngineering") as! String,
                    occupation: document.get("occupation") as! String,
                    likes: document.get("likes") as! [String],
                    matches: document.get("matches") as! [String])
                    completion(person)
                }
            }
        }
    }
    
}
