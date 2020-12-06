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
    public func insertUser(with user: User) {
        database.collection("users").document(user.emailAddress).setData(["firstName": user.firstName, "lastName": user.lastName, "uid": user.uid])
    }
    //insert photo
    public func insertPhoto(with email: String, url: String, description: String) {
        database.collection("users").document(email).setData(["photo": url, "description": description], merge: true)
    }
}

struct User {
    var firstName: String
    var lastName: String
    let emailAddress: String
    let uid: String
    var likes: [String]
    var matches: [String]
    
    var profilePictureFileName: String {
        return "\(emailAddress).png"
    }
}
