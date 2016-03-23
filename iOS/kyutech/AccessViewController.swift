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
//    var accesses:    [Access] = []
    var stations:    [Station] = []
    var directions:  [Direction] = []
    var genres:       [Genre] = []
    var genreIndex  = 0
    var fromIndex   = 0
    var toIndex     = 0
    
    var pickerVC:   AccessPickerViewController!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var constHeaderView: NSLayoutConstraint!
    @IBOutlet weak var accessHeaderView: AccessHeaderView!
    
    @IBOutlet weak var basePageView: UIView!
    
    var isCahngeCampus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setReceiveObserver()

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        AccessModel.sharedInstance.addObserver(self, forKeyPath: "genres", options: [.New, .Old], context: nil)
        AccessModel.sharedInstance.addObserver(self, forKeyPath: "stations", options: [.New, .Old], context: nil)
        AccessModel.sharedInstance.addObserver(self, forKeyPath: "directions", options: [.New, .Old], context: nil)
        //        let tracker = GAI.sharedInstance().defaultTracker
        //        tracker.set(kGAIScreenName, value: NSStringFromClass(self.classForCoder))
        //
        //        let builder = GAIDictionaryBuilder.createScreenView()
        //        tracker.send(builder.build() as [NSObject : AnyObject])
        
        if self.isCahngeCampus {
            AccessModel.sharedInstance.updateData()
            self.isCahngeCampus = false
            self.accessHeaderView.updateView()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        AccessModel.sharedInstance.removeObserver(self, forKeyPath: "genres")
        AccessModel.sharedInstance.removeObserver(self, forKeyPath: "stations")
        AccessModel.sharedInstance.removeObserver(self, forKeyPath: "directions")
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "accesses" {
//            self.setSegment()
//            self.setPageMenuView()
 
        }else if keyPath == "genres" {
            guard let arr = change?["new"] as? [Genre] else{ return }
            AccessModel.sharedInstance.removeObserver(self, forKeyPath: "genres")
            self.genres = arr
            self.setSegment()
        }else if keyPath == "stations" {
            guard let arr = change?["new"] as? [Station] else{ return }
            self.stations = arr
            self.fromValueChanged()
        }else if keyPath == "directions" {
            guard let arr = change?["new"] as? [Direction] else{ return }
            self.directions = arr
            self.toValueChanged()
        }
         
    }
    
    func setPageMenuView(){
        var vc: [UIViewController] = []
//        guard let dir = self.direction else { return }
//        for val in dir.patterns {
//            guard let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("AccessTableViewController") as? AccessTableViewController else { break }
//            //=========Viewへ===================================
//            let tt = val.timetables
//            viewController.title = val.name
//            viewController.timetables = AccessModel.sharedInstance.get6StartTimetables(tt)
//            viewController.delegate = self
//            vc.append(viewController)
//            //=========Viewへ===================================
//
//        
//        }
//        guard let pagingMenuController = self.childViewControllers.first as? PagingMenuController else { return }
//        //=========Viewへ===================================
//
//        let options = PagingMenuOptions()
//        options.menuHeight = 40
//        options.menuDisplayMode = .SegmentedControl
//        options.backgroundColor = Config.getDarkThemeColor()
//        options.menuItemMode = .Underline(height: 2, color: UIColor.whiteColor(), horizontalPadding: 0, verticalPadding: 0)
//        options.textColor       = UIColor.lightGrayColor()
//        options.selectedTextColor = UIColor.whiteColor()
//        options.selectedBackgroundColor = Config.getDarkThemeColor()
//        pagingMenuController.setup(viewControllers: vc, options: options)
//        //=========Viewへ===================================

    }
    
    func setSegment(){
        var item: [String] = []
        for val in self.genres {
           item.append(val.name)
        }
        self.segment.changeAllWithArray(item)
        
    }
    
    @IBAction func segmentValueChanged(sender: AnyObject) {
        //それぞれ過去に見たやつをきおくしておくとべんりかも
        self.toIndex = 0
        self.fromIndex = 0
        self.genreIndex = self.segment.selectedSegmentIndex
        self.headerTaped()
        AccessModel.sharedInstance.dataAnal(genreId: self.genreIndex, stationId: nil, directionId: nil)

    }
    
    func fromValueChanged(){
//        self.toIndex = 0
        if self.stations.count <= 0 { return }
//        self.station = self.line?.stations[self.fromIndex]
//        self.toValueChanged()
//        let name = self.station?.name
        self.fromLabel.text = self.stations[self.fromIndex].name
    }
    
    func toValueChanged(){
//        
        if self.directions.count <= 0 { return }
//        self.direction = self.station?.directions[self.toIndex]
//        let name = self.direction?.name
        self.toLabel.text = self.directions[self.toIndex].name
//        self.setPageMenuView()

    }
    
    @IBAction func iconTaped(sender: AnyObject) {
        self.headerTaped()
    }
    
    @IBAction func fromTaped(sender: AnyObject) {
        self.headerTaped()
        if self.stations.count <= 0 { return }
        var item: [String] = []
        for val in self.stations {
            item.append(val.name)
        }
        self.openPickerView(item, mode: .from )

    }
    
    @IBAction func toTaped(sender: AnyObject) {
        self.headerTaped()
        if self.directions.count <= 0 { return }
        var item: [String] = []
        for val in self.directions {
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
        self.pickerVC.selectIndex = mode == .from ? self.fromIndex : self.toIndex
        self.pickerVC.modalTransitionStyle = .CoverVertical
        self.pickerVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext // 背景の透過の設定
        self.presentViewController(self.pickerVC, animated: true, completion: nil)
        //=========Viewへ===================================
    }
}


extension AccessViewController: AccessPickerDelegate {
    func resultObject(object: String ,index: Int, mode: AccessPickerMode) {
        if mode == .to {
            self.toIndex = index
//            self.toValueChanged()
        }else if mode == .from {
            //かわってないならなんもせんばい
            if self.fromIndex == index { return }
           self.fromIndex = index
//            self.fromValueChanged()
        }
        AccessModel.sharedInstance.dataAnal(genreId: self.genreIndex, stationId: self.fromIndex, directionId: self.toIndex)
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


extension AccessViewController: KyutechDelagate {
    func setReceiveObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeCampus:", name: Config.notification.changeCampus, object: nil)
        
    }
    
    func changeCampus(notification: NSNotification?) {
        self.isCahngeCampus = true
    }
}

