//
//  QuestionnaireViewController2.swift
//  HashMatch
//
//  Created by Aaron Ocken on 12/6/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import UIKit

class QuestionnaireViewController2: UIViewController  {
    
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
    
    @IBAction func pressedPartying(_ sender: Any) {
    }
    
}
