//
//  PersonCell.swift
//  HashMatch
//
//  Created by Yuetong Chen on 12/2/20.
//  Copyright © 2020 Yuetong Chen. All rights reserved.
//

import UIKit
//Class for custom view controller cell
class PersonCell: UICollectionViewCell {
    let pic = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 140))
    let name = UILabel(frame: CGRect(x: 0, y: 140, width: 150, height: 60))

   override func prepareForReuse() {
       super.prepareForReuse()
       pic.removeFromSuperview()
       name.removeFromSuperview()
   }
}
