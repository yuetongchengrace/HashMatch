//
//  ViewController.swift
//  HashMatch
//
//  Created by Yuetong Chen on 11/21/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import UIKit

//Login or signup page

class ViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient = createGradient()
        self.view.layer.insertSublayer(gradient, at: 0)
        
        let size = view.frame.size.width
        let label = UILabel(frame: CGRect(x: 50, y: 300, width: size - 100, height: 50))
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 45)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "HashMatch"
        self.view.addSubview(label)
        
        registerButton.setTitle("REGISTER", for: .normal)
        registerButton.backgroundColor = .white
        registerButton.setTitleColor(.darkGray, for: .normal)
        registerButton.layer.cornerRadius = 25
        registerButton.layer.masksToBounds = true
        registerButton.titleLabel?.font = .systemFont(ofSize: 12)
        registerButton.frame = CGRect(x: 30, y: 505, width: size - 60, height: 52)
        
        loginButton.setTitle("SIGN IN", for: .normal)
        loginButton.backgroundColor = .clear
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 25
        loginButton.layer.masksToBounds = true
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.borderWidth = 2
        loginButton.titleLabel?.font = .systemFont(ofSize: 12)
        loginButton.frame = CGRect(x: 30, y: 557 + 10, width: size - 60, height: 52)
        
        let defaults = UserDefaults.standard
        if UserDefaults.standard.object(forKey: "isUserSignedIn") != nil && defaults.bool(forKey: "isUserSignedIn"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Mainpage")
            self.navigationController?.pushViewController(viewController, animated: true)
            // self.present(viewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
           navigationController?.setNavigationBarHidden(true, animated: false)
       }
    
    // TEST COMMENT !!!

}

extension UIViewController {
    func createGradient() -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        
        let colorTop =  UIColor(red: 1, green: 0.6627, blue: 0.4824, alpha: 1.0).cgColor
        
        gradient.colors = [colorTop, UIColor.red.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        return gradient
    }
}

