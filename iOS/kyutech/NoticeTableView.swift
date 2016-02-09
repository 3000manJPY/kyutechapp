//
//  NoticeTableView.swift
//  kyutech
//
//  Created by shogo okamuro on 2/10/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

class NoticeTableView: UITableView{
    var categories  : [Sort]  = []
    var departments : [Sort]  = []
    var orders      : [Sort]  = []
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        (self.categories, self.departments, self.orders) = MenuModel.sharedInstance.getMenuArrays()

    }
   
    func createCell(cell: UITableViewCell, notice: Notice) -> UITableViewCell {
        
        if let imageView = cell.viewWithTag(200) as? UIImageView,
            let backView = cell.viewWithTag(300) as? UIImageView,
            let label    = cell.viewWithTag(100) as? UILabel {
                for cate in self.categories {
                    
                    if cate.id == Int(notice.categoryId) {
                        backView.image = UIImage(named: cate.imagePath)
                        break
                    }
                }
                for depa in self.departments {
                    if depa.id  == Int(notice.departmentId) {
                        imageView.image = UIImage(named: depa.imagePath)
                        break
                    }
                }
                label.text = notice.title
        }
        return cell
    }
}
