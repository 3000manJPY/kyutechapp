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
    
        self.updateView()
    }
    
    func updateView(){
        self.backgroundColor = Config.getThemeColor()
    }
    
    
}

extension AccessViewController {
    
    func closeHeaderView(){
        UIView.animateWithDuration(0.3, // アニメーションの時間
            animations: {() -> Void  in
                // アニメーションする処理
                self.closeHeaderViewConst()
        })
    }
    
    func openHeaderView(){
        UIView.animateWithDuration(0.3, // アニメーションの時間
            animations: {() -> Void  in
                // アニメーションする処理
                self.constHeaderView.constant = 0
                self.constLineTop.constant = 8
                self.constLineView.constant = 26
                self.constHeaderHeight.constant = 180
                self.view.layoutIfNeeded()
                
        })
        
        
    }
    
    func closeHeaderViewConst(){
        self.constHeaderView.constant = -50
        self.constLineView.constant = 0
        self.constLineTop.constant = 0
        self.constHeaderHeight.constant = 140
        self.view.layoutIfNeeded()
    }
    
    
    
}