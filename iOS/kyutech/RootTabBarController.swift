//
//  RootTabBarController.swift
//  kyutech
//
//  Created by shogo okamuro on 2/5/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.appearance()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        self.iconInsets()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.iconInsets()
    }
    
    func appearance(){
        UITabBar.appearance().barTintColor = UIColor.blackColor()

        
    }
    
    func iconInsets(){
        if let items = self.tabBar.items {
            for tabBarItem in items {
                tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
            }
        }
    }
}


