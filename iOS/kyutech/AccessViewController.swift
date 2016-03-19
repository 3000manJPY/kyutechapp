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
            //=========Viewへ===================================
            let tt = val.timetables
            viewController.title = val.name
            viewController.timetables = AccessModel.sharedInstance.get6StartTimetables(tt)
            viewController.delegate = self
            vc.append(viewController)
            //=========Viewへ===================================

        
        }
        guard let pagingMenuController = self.childViewControllers.first as? PagingMenuController else { return }
        //=========Viewへ===================================

        let options = PagingMenuOptions()
        options.menuHeight = 40
        options.menuDisplayMode = .SegmentedControl
        options.backgroundColor = Config.getDarkThemeColor()
        options.menuItemMode = .Underline(height: 2, color: UIColor.whiteColor(), horizontalPadding: 0, verticalPadding: 0)
        options.textColor       = UIColor.lightGrayColor()
        options.selectedTextColor = UIColor.whiteColor()
        options.selectedBackgroundColor = Config.getDarkThemeColor()
        pagingMenuController.setup(viewControllers: vc, options: options)
        //=========Viewへ===================================

    }
    
    func setSegment(){
        var item: [String] = []
        for val in self.accesses {
           item.append(val.name)
        }
        self.segment.changeAllWithArray(item)
        self.line = self.accesses.first?.lines.first

        self.fromValueChanged()
        
    }
    
    @IBAction func segmentValueChanged(sender: AnyObject) {
        //それぞれ過去に見たやつをきおくしておくとべんりかも
        self.toIndex = 0
        self.fromIndex = 0
        self.line = self.accesses[self.segment.selectedSegmentIndex].lines.first
        self.fromValueChanged()
        self.headerTaped()
        self.setPageMenuView()

    }
    
    func fromValueChanged(){
        if self.line?.stations.count <= 0 { return }
        self.station = self.line?.stations[self.fromIndex]
        self.toValueChanged()
    }
    
    func toValueChanged(){
        if self.station?.directions.count <= 0 { return }
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
        //=========Viewへ===================================
        guard let popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("AccessPickerViewController") as? AccessPickerViewController else { return }
        self.pickerVC = popoverContent
        self.pickerVC.delegate = self
        self.pickerVC.list = list
        self.pickerVC.mode = mode
        self.pickerVC.modalTransitionStyle = .CoverVertical
        self.pickerVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext // 背景の透過の設定
        self.presentViewController(self.pickerVC, animated: true, completion: nil)
        //=========Viewへ===================================
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

//=========Utilへ===================================
extension UISegmentedControl {
    func changeAllWithArray(arr: [String]){
        self.removeAllSegments()
        for str in arr {
            self.insertSegmentWithTitle(str, atIndex: self.numberOfSegments, animated: false)
        }
        self.selectedSegmentIndex = 0
    }
    
}
//=========Utilへ==================================
