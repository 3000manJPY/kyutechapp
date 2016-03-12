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
    }
    
    func setContentItem(){
        self.title_label.text = "掲示板"
        self.category_open.setImage(UIImage(named: "filter-button"), forState: .Normal)
        self.category_open.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.search_btn.setImage(UIImage(named: "Refresh_white"), forState: .Normal)
        self.search_btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        let campus = Config.getCampusId()
        switch campus {
        case CAMPUS.tobata.val:
            self.top_image.image = CAMPUS.tobata.topImage
            break
        case CAMPUS.iizuka.val:
            self.top_image.image = CAMPUS.iizuka.topImage
            break
        case CAMPUS.wakamatsu.val:
            self.top_image.image = CAMPUS.wakamatsu.topImage
            break
        default: break
            
        }
        
        self.contentView.backgroundColor = Config.getThemeColor()
    }
    
}
