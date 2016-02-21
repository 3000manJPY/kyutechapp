//
//  NoticeNavigationController.swift
//  kyutech
//
//  Created by shogo okamuro on 2/8/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
import SHUtil

class NoticeNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "panGestureRecognized:"))
    }
    internal func panGestureRecognized(sender: UIPanGestureRecognizer){
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.panGestureRecognized(sender)
    }
}