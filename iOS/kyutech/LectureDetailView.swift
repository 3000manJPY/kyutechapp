//
//  NoticeDetailView.swift
//  kyutech
//
//  Created by shogo okamuro on 2/10/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
import TTTAttributedLabel


class LectureDetailView: UITableView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.settingTableView()
    }
    func settingTableView(){
        self.estimatedRowHeight = 90
        self.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func createHeadView(section: Int, title: String) -> UIView {
        let headerView = UIView(frame: CGRectMake(0, 0, self.bounds.size.width , 22))
        headerView.backgroundColor = section % 2 == 0 ? UIColor(colorLiteralRed: 0, green: 138.0 / 255.0 , blue: 215.0 / 255.0 , alpha: 1.0) : UIColor(colorLiteralRed: 107.0 / 255.0 , green: 179.0 / 255.0 , blue: 220.0 / 255.0 , alpha: 1.0)
        let header = UILabel(frame: CGRectMake(5, 0, self.bounds.size.width, 27))
        header.backgroundColor = UIColor.whiteColor()
        header.text = title
        headerView.addSubview(header)
        
        return headerView
    }
    
}
