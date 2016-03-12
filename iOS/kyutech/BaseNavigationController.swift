//
//  BaseNavigationController.swift
//  kyutech
//
//  Created by shogo okamuro on 3/12/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.customAppearance()
    }
}

extension UINavigationController {
    func customAppearance(){
        self.navigationBar.barTintColor = Config.getThemeColor()
    }
    
}
