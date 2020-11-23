//
//  OnboardingDescribeYourselfVC.swift
//  HashMatch
//
//  Created by Ashley Lin on 11/23/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import UIKit

class OnboardingDescribeYourselfVC: UIViewController {

    @IBOutlet weak var nextbtn: UIButton!
    @IBOutlet weak var describeYourselfTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        describeYourselfTextView.textViewDesign()
        nextbtn.applyPrimaryBtnDesign()
        // Do any additional setup after loading the view.
    }
}
