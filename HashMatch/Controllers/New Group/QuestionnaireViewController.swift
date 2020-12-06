//
//  QuestionnaireViewController.swift
//  HashMatch
//
//  Created by Ashley Lin on 11/23/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import UIKit

class QuestionnaireViewController: UIViewController {


    @IBOutlet weak var nextbtn: UIButton!
    @IBOutlet weak var questionnaireAns1: UIButton!
    @IBOutlet weak var questionnaireAns2: UIButton!
    @IBOutlet weak var questionnaireAns3: UIButton!
    @IBOutlet weak var questionnaireAns4: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        nextbtn.applyPrimaryBtnDesign()
        questionnaireAns1.applyPrimaryBtnDesign()
        questionnaireAns2.applyPrimaryBtnDesign()
        questionnaireAns3.applyPrimaryBtnDesign()
        questionnaireAns4.applyPrimaryBtnDesign()
    }
}
