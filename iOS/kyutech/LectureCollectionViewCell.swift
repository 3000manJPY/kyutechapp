//
//  LectureCollectionViewCell.swift
//  kyutech
//
//  Created by shogo okamuro on 2/11/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

class LectureCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var roomImageView: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var room: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
