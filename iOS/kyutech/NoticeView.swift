//
//  NoticeView.swift
//  kyutech
//
//  Created by shogo okamuro on 2/10/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
import SHUtil

public class NoticeView: SHContentTableView {
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.setContentItem()
    }
    
    func setContentItem(){
        self.title_label.text = "掲示板"
        self.category_open.setImage(UIImage(named: "filter"), forState: .Normal)
        self.sub_category_open.setImage(UIImage(named: "filter-button"), forState: .Normal)
        self.category_open.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.search_btn.setImage(UIImage(named: "Refresh_white"), forState: .Normal)
        self.search_btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.sub_search_btn.setImage(UIImage(named: "reload"), forState: .Normal)
        self.sub_search_btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.top_image.image = UIImage(named: "top_image")
        self.navi_imageview.image = UIImage(named: "news_Ellipse")
    }
    
}
