//
//  SplashViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 2/4/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
import SHUtil

class SplashViewController: UIViewController {
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var mainLogoImageView: UIImageView!
    @IBOutlet weak var logoStringImageView: UIImageView!
    var noticeOpen = false
    var lectureOpen = false
    var accessOpen = false
    var notif: [NSObject:AnyObject] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        motionEffect()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openNotice:", name: Notif.notice.open, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openLecture:", name: Notif.lecture.open, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openAccess:", name: Notif.access.open, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        let tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: NSStringFromClass(self.classForCoder))
//        
//        let builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.backImageView = nil
        self.mainLogoImageView = nil
        self.logoStringImageView = nil
        self.sendNotif()
    }
    
    override func viewDidAppear(animated: Bool) {
        //少し縮小するアニメーション
        UIView.animateWithDuration(0.3,
            delay: 1.0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: { () in
                self.mainLogoImageView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            }, completion: { (Bool) in
                self.nextViewController()
        })
        //拡大させて、消えるアニメーション
        UIView.animateWithDuration(0.2,
            delay: 1.3,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: { () in
                self.mainLogoImageView.transform = CGAffineTransformMakeScale(2.0, 2.0)
                self.mainLogoImageView.alpha = 0
                self.logoStringImageView.alpha = 0
            }, completion: { (Bool) in
                self.mainLogoImageView.hidden = true
                self.logoStringImageView.hidden = true
        })
    }
    func motionEffect(){
        // ①視差効果の作成
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -16.0
        xMotion.maximumRelativeValue = 16.0
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -16.0
        yMotion.maximumRelativeValue = 16.0
        // ②作成した視差効果をグループ化
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        // ③Viewにセット
        backImageView.addMotionEffect(group)
    }
    func nextViewController(){ self.performSegueWithIdentifier("open", sender: nil) }
    func openNotice(notification: NSNotification) {
        if let info = notification.userInfo {
            self.noticeOpen = true
            self.notif = info
        }
    }
    
    func openLecture(notification: NSNotification) {
        if let info = notification.userInfo {
            self.lectureOpen = true
            self.notif = info
        }
    }
    func openAccess(notification: NSNotification) {
        if let info = notification.userInfo {
            self.accessOpen = true
            self.notif = info
        }
    }
    func sendNotif() {
        if self.noticeOpen {
            NSNotificationCenter.defaultCenter().postNotificationName(Notif.notice.open, object: nil, userInfo: self.notif)
            self.noticeOpen = false
        }else if self.lectureOpen {
            
            self.lectureOpen = false
        }else if self.accessOpen {
            
            self.accessOpen = false
        }
        self.notif = [:]
    }
}
