//
//  AccessViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 2/23/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
import SHUtil
import PagingMenuController
import RealmSwift

enum AccessPickerMode :Int {
    case from = 1
    case to = 2
}

class AccessViewController: UIViewController {
    var accesses: [Access] = []
    var line:       Line?
    var station:    Station?
    var pattern:    Pattern?
    var direction:  Direction?
    
    var fromIndex   = 0
    var toIndex     = 0
    
    var pickerVC:   AccessPickerViewController!
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var constHeaderView: NSLayoutConstraint!
    @IBOutlet weak var accessHeaderView: AccessHeaderView!
    
    @IBOutlet weak var basePageView: UIView!
    
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
            self.setPageMenuView()
 
        }
         
    }
    
    func setPageMenuView(){
        var vc: [UIViewController] = []
        guard let dir = self.direction else { return }
        for val in dir.patterns {
            guard let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("AccessTableViewController") as? AccessTableViewController else { break }
            let tt = val.timetables
            viewController.title = val.name
            viewController.timetables = tt
            viewController.delegate = self
            vc.append(viewController)
        
        }
        guard let pagingMenuController = self.childViewControllers.first as? PagingMenuController else { return }
        
        let options = PagingMenuOptions()
        options.menuHeight = 40
        options.menuDisplayMode = .SegmentedControl
        pagingMenuController.setup(viewControllers: vc, options: options)
    }
    
    func setSegment(){
        var item: [String] = []
        for val in self.accesses {
           item.append(val.name)
        }
        self.segment.changeAllWithArray(item)
        self.line = self.accesses[self.segment.selectedSegmentIndex].lines[0]

        self.fromValueChanged()
        
    }
    
    @IBAction func segmentValueChanged(sender: AnyObject) {
        //それぞれ過去に見たやつをきおくしておくとべんりかも
        self.toIndex = 0
        self.fromIndex = 0
        self.line = self.accesses[self.segment.selectedSegmentIndex].lines[0]
        self.fromValueChanged()
        self.headerTaped()
        self.setPageMenuView()

    }
    
    func fromValueChanged(){
        self.station = self.line?.stations[self.fromIndex]
        self.toValueChanged()
    }
    
    func toValueChanged(){
        self.direction = self.station?.directions[self.toIndex]
        
    }
    
    @IBAction func iconTaped(sender: AnyObject) {
        self.headerTaped()
    }
    
    @IBAction func fromTaped(sender: AnyObject) {
        self.headerTaped()
        var item: [String] = []
        guard let line = self.line else { return }
        for val in line.stations {
            item.append(val.name)
        }
        self.openPickerView(item, mode: .from )

    }
    
    @IBAction func toTaped(sender: AnyObject) {
        self.headerTaped()
        var item: [String] = []
        guard let station = self.station else { return }
        for val in station.directions {
            item.append(val.name)
        }
        self.openPickerView(item, mode: .to)
        
    }
    
    func headerTaped(){
        self.openHeaderView(self.constHeaderView)
        self.view.layoutIfNeeded()
    }
        
    func openPickerView(list: [String], mode: AccessPickerMode){
        guard let popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("AccessPickerViewController") as? AccessPickerViewController else { return }
        self.pickerVC = popoverContent
        self.pickerVC.delegate = self
        self.pickerVC.list = list
        self.pickerVC.mode = mode
        self.pickerVC.modalTransitionStyle = .CoverVertical
        self.pickerVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext // 背景の透過の設定
        self.presentViewController(self.pickerVC, animated: true, completion: nil)
    }
}


extension AccessViewController: AccessPickerDelegate {
    func resultIndex(index: Int, mode: AccessPickerMode) {
    
        if mode == .to {
            self.toIndex = index
            self.toValueChanged()
        }else if mode == .from {
           self.fromIndex = index
            self.fromValueChanged()
        }
    }
}

extension AccessViewController: AccessScrollViewDelegate {
    func accessScrollViewWillBeginDragging(scrollView: UIScrollView){
        self.closeHeaderView(self.constHeaderView)
 
    }
    func accessScrollViewDidScroll(scrollView: UIScrollView){
        let y = scrollView.contentOffset.y
        if y <= -10 {
            self.openHeaderView(self.constHeaderView)
            self.view.layoutIfNeeded()
        }
    }
    func accessScrollViewWillBeginDecelerating(scrollView: UIScrollView){
        self.closeHeaderView(self.constHeaderView)
 
    }
}


extension UISegmentedControl {
    func changeAllWithArray(arr: [String]){
        self.removeAllSegments()
        for str in arr {
            self.insertSegmentWithTitle(str, atIndex: self.numberOfSegments, animated: false)
        }
        self.selectedSegmentIndex = 0
    }
    
}