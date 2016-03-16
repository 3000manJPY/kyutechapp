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
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var constHeaderView: NSLayoutConstraint!
    @IBOutlet weak var accessHeaderView: AccessHeaderView!
    
    @IBOutlet weak var tableView: AccessTableView!
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
            self.setSegment()
 
        }
         
    }
    
    func setSegment(){
        let item = ["JR","西鉄バス","スクールバス"]
        
        let frame = self.segment.frame
        self.segment.removeFromSuperview()
        let newSegment = UISegmentedControl(items: item)
        newSegment.frame = frame
        newSegment.tintColor = UIColor.whiteColor()
        self.accessHeaderView.addSubview(newSegment)

    }
    
    @IBAction func segmentValueChanged(sender: AnyObject) {
        self.headerTaped()
    }
    
    @IBAction func iconTaped(sender: AnyObject) {
        self.headerTaped()
    }
    
    @IBAction func fromTaped(sender: AnyObject) {
        self.headerTaped()
        self.openPickerView()
    }
    
    @IBAction func toTaped(sender: AnyObject) {
        self.headerTaped()
        self.openPickerView()
        
    }
    
    func headerTaped(){
        SHprint("aaaaaa")
        self.openHeaderView()
    }
 
    func closeHeaderView(){
        UIView.animateWithDuration(0.3, // アニメーションの時間
            animations: {() -> Void  in
                // アニメーションする処理
                self.constHeaderView.constant = -50
                self.view.layoutIfNeeded()

        })
    }
    
    func openHeaderView(){
        UIView.animateWithDuration(0.3, // アニメーションの時間
            animations: {() -> Void  in
                // アニメーションする処理
                self.constHeaderView.constant = 0
                self.view.layoutIfNeeded()

        })

    
    }
    
    func openPickerView(){
        guard let popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("AccessPickerViewController") as? AccessPickerViewController else { return }
        popoverContent.modalTransitionStyle = .CoverVertical
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext // 背景の透過の設定
        self.presentViewController(popoverContent, animated: true, completion: nil)
    }
}



extension AccessViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
//        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}

extension AccessViewController: UIScrollViewDelegate {
//    - (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    scrollBeginingPoint = [scrollView contentOffset];
//    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.closeHeaderView()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if y <= 0 {
            self.openHeaderView()
        }
    }
}