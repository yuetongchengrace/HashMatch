//
//  Structs.swift
//  HashMatch
//
//  Created by Yuetong Chen on 12/2/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import Foundation
import UIKit

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
    let gender: String
    let preference: String
    var likes: [String]
    var matches: [String]
    
}

extension Person {
    init() {
        self.init(email: "", firstName: "", lastName: "", uid: "", photo: "", description: "", age: "", city: "", state: "", education: "", fieldOfEngineering: "", occupation: "", quizScore: 0, gender: "", preference: "", likes: [""], matches: [""])
    }
}

struct ActivityIndicator {
    
    let viewForActivityIndicator = UIView()
    let view: UIView
    let navigationController: UINavigationController?
    let tabBarController: UITabBarController?
    let activityIndicatorView = UIActivityIndicatorView()
    let loadingTextLabel = UILabel()
    
    var navigationBarHeight: CGFloat { return navigationController?.navigationBar.frame.size.height ?? 0.0 }
    var tabBarHeight: CGFloat { return tabBarController?.tabBar.frame.height ?? 0.0 }
    
    func showActivityIndicator() {
        viewForActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        viewForActivityIndicator.backgroundColor = .white
        view.addSubview(viewForActivityIndicator)
        
        activityIndicatorView.center = CGPoint(x: self.view.frame.size.width / 2.0, y: (self.view.frame.size.height - tabBarHeight - navigationBarHeight) / 2.0)
        
        loadingTextLabel.textColor = UIColor.black
        loadingTextLabel.text = "LOADING PEOPLE"
        loadingTextLabel.font = UIFont(name: "Avenir Light", size: 10)
        loadingTextLabel.sizeToFit()
        loadingTextLabel.center = CGPoint(x: activityIndicatorView.center.x, y: activityIndicatorView.center.y + 30)
        viewForActivityIndicator.addSubview(loadingTextLabel)
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .medium
        viewForActivityIndicator.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    func stopActivityIndicator() {
        viewForActivityIndicator.removeFromSuperview()
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
}
