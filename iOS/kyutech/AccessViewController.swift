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
    var genreId:Int  = 1
    var fromId :Int? = nil
    var toId   :Int? = nil
    
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
        AccessModel.sharedInstance.addObserver(self, forKeyPath: "patterns", options: [.New, .Old], context: nil)
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
        AccessModel.sharedInstance.removeObserver(self, forKeyPath: "patterns")
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "accesses" {
//            self.setSegment()
//            self.setPageMenuView()
 
        }else if keyPath == "genres" {
            guard let arr = change?["new"] as? [Genre] else{ return }
            self.genres = arr
            self.setSegment()
            AccessModel.sharedInstance.updateDataAnal(genreId: self.genreId, stationId: nil, directionId: nil)
        }else if keyPath == "stations" {
            guard let arr = change?["new"] as? [Station] else{ return }
            self.stations = arr
            self.fromValueChanged()
        }else if keyPath == "directions" {
            guard let arr = change?["new"] as? [Direction] else{ return }
            self.directions = arr
            self.toValueChanged()
        }else if keyPath == "patterns" {
            guard let arr = change?["new"] as? [Pattern] else{ return }
            self.setPageMenuView(arr)
        }
         
    }
    
    func setPageMenuView(patterns: [Pattern]){
        var vc: [UIViewController] = []
        for val in patterns {
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
        if self.genres.count <= 0 { return }
        var item: [String] = []
        for val in self.genres {
           item.append(val.name)
        }
        self.segment.changeAllWithArray(item)
        
    }
    
    @IBAction func segmentValueChanged(sender: AnyObject) {
        //それぞれ過去に見たやつをきおくしておくとべんりかも
        self.toId = nil
        self.fromId = nil
//        self.genreId = self.segment.selectedSegmentIndex + 1
        self.genreId = self.genres[self.segment.selectedSegmentIndex].id
        self.headerTaped()
        AccessModel.sharedInstance.updateDataAnal(genreId: self.genreId, stationId: nil, directionId: nil)

    }
    
    func fromValueChanged(){
//        guard let num = self.fromIndex else{ return }
//        self.toIndex = 0
//        if self.stations.count <= self.fromIndex { return }
//        self.station = self.line?.stations[self.fromIndex]
//        self.toValueChanged()
//        let name = self.station?.name
        if let id = self.fromId {
            let s = self.stations.filter{$0.id == id}.first
            self.fromLabel.text = s?.name
        }else{
            self.fromLabel.text = "(選択なし)"
    
        }
    }
    
    func toValueChanged(){
//        if nil != self.toIndex {
//            let num = self.toIndex!
//        if self.directions.count <= self.toIndex { return }
////        self.direction = self.station?.directions[self.toIndex]
////        let name = self.direction?.name
//        self.toLabel.text = self.directions[self.toIndex].name
//        self.setPageMenuView()
//            }else{ return }
        
        if let id = self.toId {
            let s = self.directions.filter{$0.id == id}.first
            self.toLabel.text = s?.name
        }else{
            self.toLabel.text = "(選択なし)"
            
        }

    }
    
    @IBAction func iconTaped(sender: AnyObject) {
        self.headerTaped()
    }
    
    @IBAction func fromTaped(sender: AnyObject) {
        self.headerTaped()
        AccessModel.sharedInstance.updateDataAnal(genreId: self.genreId, stationId: nil, directionId: self.toId)
        if self.stations.count <= 0 { return }
        var item: [(String,Bool,Int?)] = [("(選択なし)",false,nil)]
        for val in self.stations {
            item.append((val.name,val.enablet,val.id))
        }
        self.openPickerView(item, mode: .from )

    }
    
    @IBAction func toTaped(sender: AnyObject) {
        self.headerTaped()
        AccessModel.sharedInstance.updateDataAnal(genreId: self.genreId, stationId: self.fromId, directionId: nil)
        if self.directions.count <= 0 { return }
        var item: [(String,Bool,Int?)] = [("(選択なし)",false,nil)]
        for val in self.directions {
            if val.enablet == true { continue }
            item.append((val.name,val.enablet,val.id))
        }
        self.openPickerView(item, mode: .to)
        
    }
    
    func headerTaped(){
        self.openHeaderView(self.constHeaderView)
        self.view.layoutIfNeeded()
    }
        
    func openPickerView(list: [(String,Bool,Int?)], mode: AccessPickerMode){
        //=========Viewへ===================================
        guard let popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("AccessPickerViewController") as? AccessPickerViewController else { return }
        self.pickerVC = popoverContent
        self.pickerVC.delegate = self
        self.pickerVC.list = list
        self.pickerVC.mode = mode
        if mode == .from {
            self.pickerVC.selectId = self.fromId
        }else if mode == .to {
            self.pickerVC.selectId = self.toId
        }
//        self.pickerVC.selectIndex = mode == .from ? self.fromIndex : self.toIndex
        self.pickerVC.modalTransitionStyle = .CoverVertical
        self.pickerVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext // 背景の透過の設定
        self.presentViewController(self.pickerVC, animated: true, completion: nil)
        //=========Viewへ===================================
    }
}


extension AccessViewController: AccessPickerDelegate {
//    func resultObject(object: (String,Bool,Int) ,id id: Int?, mode: AccessPickerMode) {
    func resultObject(object: (String, Bool, Int?), id: Int?, mode: AccessPickerMode) {
        
        if mode == .from {
            //かわってないならなんもせんばい
            if self.fromId == id { return }
           self.fromId = id
            if object.1 == true {
                self.toId = nil
            }

        }else if mode == .to {
            if self.toId == id { return }
            self.toId = id

        }
        AccessModel.sharedInstance.updateDataAnal(genreId: self.genreId, stationId: self.fromId, directionId: self.toId)

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

