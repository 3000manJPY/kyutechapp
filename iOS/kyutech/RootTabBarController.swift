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
        self.customAppearance()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.iconInsets()
    }
    
    
    
    
    func iconInsets(){
        if let items = self.tabBar.items {
            for tabBarItem in items {
                tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
            }
        }
    }
}


extension UITabBarController {
    public func customAppearance(){
        self.tabBar.barTintColor = Config.getThemeColor()
    }
    
    func allItemEnablet(enablet:Bool) {
        guard let items = self.tabBar.items else{ return }
        for item in items{
            item.enabled = enablet
            
        }
    }

}


