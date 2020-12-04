//
//  LogoutViewController.swift
//  HashMatch
//
//  Created by Yuetong Chen on 12/2/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import UIKit
//This is the user setting page
//We can pull user information from the users collection and display on corresponding fields
class LogoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func logoutClicked(_ sender: Any) {
        // UserDefaults.standard.set(false, forKey: "isUserSignedIn")
        UserDefaults.standard.removeObject(forKey: "isUserSignedIn")
        UserDefaults.standard.removeObject(forKey: "user")
        print(UserDefaults.standard.dictionaryRepresentation())
        navigationController?.popToRootViewController(animated: true)
//        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "baseVC") as UIViewController
//        navigationController?.viewControllers = [rootVC]
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = rootVC
        //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
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
