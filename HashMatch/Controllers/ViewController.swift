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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let defaults = UserDefaults.standard
        if UserDefaults.standard.object(forKey: "isUserSignedIn") != nil && defaults.bool(forKey: "isUserSignedIn"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Mainpage")
            self.navigationController?.pushViewController(viewController, animated: true)
            // self.present(viewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
           navigationController?.setNavigationBarHidden(false, animated: false)
       }
    
    // TEST COMMENT !!!

}

