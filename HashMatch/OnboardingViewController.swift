//
//  OnboardingViewController.swift
//  HashMatch
//
//  Created by Ashley Lin on 11/22/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var nextBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide navigation bar so that the user cannot click back to the signup page
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
        nextBtn.applyPrimaryBtnDesign()
    }
}
extension UIButton{
    func applyPrimaryBtnDesign(){
        self.layer.cornerRadius = 20.0
    }
}
extension UITextView{
    func textViewDesign(){
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
