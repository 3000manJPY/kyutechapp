//
//  RootNoticeViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 2/8/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
import REFrostedViewController

class RootNoticeViewController: REFrostedViewController {
    override func awakeFromNib() {
        self.contentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NoticeNavigationController")
        self.menuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MenuTableViewController")
    }
}
