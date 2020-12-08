//
//  QuestionViewController4.swift
//  HashMatch
//
//  Created by Yuetong Chen on 12/6/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import UIKit

class QuestionViewController4: UIViewController {

    //@IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var questionnaireAns1: UIButton!
    @IBOutlet weak var questionnaireAns2: UIButton!
    @IBOutlet weak var questionnaireAns3: UIButton!
    @IBOutlet weak var questionnaireAns4: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //nextBtn.applyPrimaryBtnDesign()
        questionnaireAns1.applyPrimaryBtnDesign()
        questionnaireAns2.applyPrimaryBtnDesign()
        questionnaireAns3.applyPrimaryBtnDesign()
        questionnaireAns4.applyPrimaryBtnDesign()
        // Do any additional setup after loading the view.
    }
    
    /*
    @IBAction func clickedFinish(_ sender: Any) {
        let defaults = UserDefaults.standard
        var savedScore:Int = 0
        savedScore = QuestionViewController1.score
        print(savedScore)
        defaults.set(savedScore, forKey: "score")
                
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "Mainpage")
        // self.present(secondViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    */
    
    func finQues() {
        let defaults = UserDefaults.standard
        var savedScore:Int = 0
        savedScore = QuestionViewController1.score
        print(savedScore)
        defaults.set(savedScore, forKey: "score")
                
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "Mainpage")
        // self.present(secondViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    @IBAction func playSportsSelected(_ sender: Any) {
        QuestionViewController1.score = 4 + QuestionViewController1.score
        finQues()
    }
    
    @IBAction func fantasySelected(_ sender: Any) {
        QuestionViewController1.score = 2 + QuestionViewController1.score
        finQues()
    }
    
    @IBAction func runnerSelected(_ sender: Any) {
        QuestionViewController1.score = 3 + QuestionViewController1.score
        finQues()
    }
    
    @IBAction func noSportsSelected(_ sender: Any) {
        QuestionViewController1.score = 1 + QuestionViewController1.score
        finQues()
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
