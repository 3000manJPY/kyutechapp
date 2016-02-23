//
//  AccessViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 2/23/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
import SHUtil

class AccessViewController: UIViewController {
    var accesses: [Access] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.accesses = AccessModel.sharedInstance.accesses
        
    
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        AccessModel.sharedInstance.addObserver(self, forKeyPath: "accesses", options: [.New, .Old], context: nil)
        //        let tracker = GAI.sharedInstance().defaultTracker
        //        tracker.set(kGAIScreenName, value: NSStringFromClass(self.classForCoder))
        //
        //        let builder = GAIDictionaryBuilder.createScreenView()
        //        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        AccessModel.sharedInstance.removeObserver(self, forKeyPath: "accesses")
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "accesses" {
            guard let arr = change?["new"] as? [Access] else{ return }
            self.accesses = arr
            
            SHprint(self.accesses)
//            self.lecCollectionView.reloadData()
        }
         
    }
}
