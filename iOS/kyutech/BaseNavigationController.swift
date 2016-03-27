//
//  BaseNavigationController.swift
//  kyutech
//
//  Created by shogo okamuro on 3/12/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseNavigationController.openNotice(_:)), name: Config.notification.notice.open, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseNavigationController.openLecture(_:)), name: Config.notification.lecture.open, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseNavigationController.openAccess(_:)), name: Config.notification.access.open, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.customAppearance()
    }
    func openNotice(notification: NSNotification) {
        if let info = notification.userInfo {
            guard let noticeId = info["id"] as? String else{ return }
            let storyboard = UIStoryboard(name: "NoticeDetail", bundle: nil)
            NoticeModel.sharedInstance.reqestNotice(noticeId, campus: Config.getCampusId(), completion: { (notice) in
                
                if let vc = storyboard.instantiateViewControllerWithIdentifier("NoticeDetailViewController") as? NoticeDetailViewController {
                    vc.notice = notice
                    self.presentViewController(vc , animated: true, completion: nil)

                }
            })
        }
    }
    
    
    func openLecture(notification: NSNotification?) {
        
    }
    
    func openAccess(notification: NSNotification?) {
        
    }
}

extension UINavigationController {
    func customAppearance(){
        self.navigationBar.barTintColor = Config.getThemeColor()
    }
    
}
