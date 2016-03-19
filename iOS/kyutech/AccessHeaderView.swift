//
//  AccessHeaderView.swift
//  kyutech
//
//  Created by shogo okamuro on 3/16/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit


class AccessHeaderView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = Config.getThemeColor()
    }
    
    
}

extension AccessViewController {
    
    func closeHeaderView(const: NSLayoutConstraint){
        UIView.animateWithDuration(0.3, // アニメーションの時間
            animations: {() -> Void  in
                // アニメーションする処理
                const.constant = -50
                self.view.layoutIfNeeded()
                
        })
    }
    
    func openHeaderView(const: NSLayoutConstraint){
        UIView.animateWithDuration(0.3, // アニメーションの時間
            animations: {() -> Void  in
                // アニメーションする処理
                const.constant = 0
                self.view.layoutIfNeeded()
                
        })
        
        
    }
    
    
    
    
    
}