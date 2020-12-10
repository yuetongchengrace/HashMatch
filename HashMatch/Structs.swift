//
//  Structs.swift
//  HashMatch
//
//  Created by Yuetong Chen on 12/2/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import Foundation

struct Person {
    var email: String
    var firstName: String
    var lastName: String
    let uid: String
    let photo: String
    let description: String
    let age: String
    let city: String
    let state: String
    let education: String
    let fieldOfEngineering: String
    let occupation: String
    let quizScore: Int
    var likes: [String]
    var matches: [String]
    
}

extension Person {
    init() {
        self.init(email: "", firstName: "", lastName: "", uid: "", photo: "", description: "", age: "", city: "", state: "", education: "", fieldOfEngineering: "", occupation: "", quizScore: 0, likes: [""], matches: [""])
    }
}
