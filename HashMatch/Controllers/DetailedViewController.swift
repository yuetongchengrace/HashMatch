//
//  DetailedViewController.swift
//  HashMatch
//
//  Created by Yuetong Chen on 12/5/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    var person: Person?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        guard let p = person else { return }
        //Put these into corresponding fields~
        print(p.email)
        print(p.photo)
        print(p.description)
        print(p.lastName)
        print(p.firstName)
        print(p.uid)
        print(p.age)
        print(p.city)
        print(p.state)
        print(p.education)
        print(p.fieldOfEngineering)
        print(p.occupation)
        
        //add Image
        let url = URL(string: p.photo)
        if let img = try? Data(contentsOf: url!){
            imageView.image = UIImage(data:img)
        }
        //add corresponding information to the fields
        
        // Do any additional setup after loading the view.
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
