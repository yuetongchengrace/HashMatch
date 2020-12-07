//
//  QuestionViewController2.swift
//  HashMatch
//
//  Created by Yuetong Chen on 12/6/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import UIKit

class QuestionViewController2: UIViewController {

    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var questionnaireAns1: UIButton!
    @IBOutlet weak var questionnaireAns2: UIButton!
    @IBOutlet weak var questionnaireAns3: UIButton!
    @IBOutlet weak var questionnaireAns4: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.applyPrimaryBtnDesign()
        questionnaireAns1.applyPrimaryBtnDesign()
        questionnaireAns2.applyPrimaryBtnDesign()
        questionnaireAns3.applyPrimaryBtnDesign()
        questionnaireAns4.applyPrimaryBtnDesign()
        // Do any additional setup after loading the view.
    }
    @IBAction func clickNext(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let questionViewController3 = storyboard.instantiateViewController(withIdentifier: "Q3")
        // self.present(secondViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(questionViewController3, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
