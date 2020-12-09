//
//  PplMatchedViewController.swift
//  HashMatch
//
//  Created by Ashley Lin on 12/8/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import UIKit

class PplMatchedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var pplMatchedTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        pplMatchedTableView.delegate = self
        pplMatchedTableView.dataSource = self
        setupTableView()
        fetchDataForTableView()
        cacheImages()
    }
    
    var people: [Person] = []
    var images: [Int:UIImage] = [:]
    
    struct Info: Codable{
        var name: String
        var description: String
        var image_url: String
    }
    var theData: [Info] = []
    var theImageCache: [UIImage] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theData.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "PplMatchedTableViewCell")
        let profileUIView = UIView(frame: cell.bounds)
        
        let cgrect1 = CGRect.init(x: 15, y: 15, width: 50, height: 50)
        let profilePicture = UIImageView.init(frame: cgrect1)
        profilePicture.image = theImageCache[indexPath.row]
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true
        
        let cgrect2 = CGRect.init(x: 80, y: 13, width: 270, height: 20)
        let fullName = UILabel.init(frame: cgrect2)
        fullName.text = theData[indexPath.row].name
        //fullName.text = Person.firstName
        fullName.font = UIFont(name: "Kohinoor-Gujarati-Regular", size: 16.0)
        fullName.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        let cgrect3 = CGRect.init(x: 80, y: 105, width: 270, height: 20)
        let personDetails = UILabel.init(frame: cgrect3)
        personDetails.text = theData[indexPath.row].name
        personDetails.font = UIFont(name: "Kohinoor-Gujarati-Regular", size: 9.0)
        
        profileUIView.addSubview(profilePicture)
        profileUIView.addSubview(fullName)
        profileUIView.addSubview(personDetails)
        
        cell.contentView.addSubview(profileUIView)

        return cell
    }
    
    func setupTableView(){
        pplMatchedTableView.dataSource = self
        pplMatchedTableView.register(UITableViewCell.self, forCellReuseIdentifier: "PplMatchedTableViewCell")
    }

    func fetchDataForTableView(){
        let url = URL(string: "https://research.engineering.wustl.edu/~todd/studio.json")
        let data = try! Data(contentsOf: url!)
        theData=try! JSONDecoder().decode([Info].self, from:data)
    }
    
    func cacheImages(){
        //URL
        //Data
        //UIImage
        for item in theData{
            let url = URL(string: item.image_url)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            theImageCache.append(image!)
        }
    }
}
