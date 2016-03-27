//
//  NoticeNavigationController.swift
//  kyutech
//
//  Created by shogo okamuro on 2/8/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
import SHUtil

class NoticeNavigationController: BaseNavigationController {

    var gesture: UIPanGestureRecognizer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gesture = UIPanGestureRecognizer(target: self, action: #selector(NoticeNavigationController.panGestureRecognized(_:)))
    }
    
    func addGesture() {
        if let g = self.gesture {
            self.view.addGestureRecognizer(g)
        }
    }
    
    func removeGesture() {
        
        if let g = self.gesture {
            self.view.removeGestureRecognizer(g)
        }
    }
    internal func panGestureRecognized(sender: UIPanGestureRecognizer){
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.panGestureRecognized(sender)
    }
}