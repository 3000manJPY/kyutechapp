//
//  LectureCollectionViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 2/10/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

enum LECTUREMODE: Int {
    case Edit   = 1
    case Normal = 0
    
    mutating func togle(){
        self = (self == .Edit) ? .Normal :.Edit
    }
}

class LectureCollectionViewController: UIViewController {
    
    var myLectureArray : [Lecture] = []
    var syllabusArray  : [Lecture] = []
    
//    var term = Term.First.rawValue
//    var destinationviewcontroller: TimeTableDetailViewController?
    
    var mode = LECTUREMODE.Normal
    
//    var popoverContent:PopoverSubjectViewController!
    
    @IBOutlet weak var centerBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var allSelectBtn: UIButton!
    @IBOutlet weak var lecCollectionView: LectureCollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allSelectBtn.enabled = false
//        self.setBackImage()

        
        guard let titleWidth = self.centerBtn.titleLabel?.bounds.size.width,
              let imageWidth = self.centerBtn.imageView?.bounds.size.width else { return }
        self.centerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth)
        self.centerBtn.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth)
        
        self.lecCollectionView.registerNib(UINib(nibName: "LectureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LectureCollectionViewCell")
       
        self.myLectureArray = LectueModel.sharedInstance.myLectures
        LectueModel.sharedInstance.addObserver(self, forKeyPath: "myLectures", options: [.New, .Old], context: nil)
        
//        if !Config.isLectureUpdate() {
//            
//            self.updateData()
//        }else{
//            
//            //                        dispatch_async(dispatch_queue_create("com.hoge.app.serial", DISPATCH_QUEUE_SERIAL), {
//            //        //前表示の時間割を表示する
//            if let term = NSUserDefaults.standardUserDefaults().objectForKey("term") as? Int{
//                self.term = term == 0 ? 1 : term
//            }else{
//                self.term = Term.First.rawValue
//            }
//            self.getTimeTableData(self.term)
//            self.setTermTitle(self.term)
//            //        })
//        }
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        let tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: NSStringFromClass(self.classForCoder))
//        
//        let builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        setCollectionViewInset()
//        updateFrame()
    }
    
    
    @IBAction func editModePushed(sender: AnyObject) {
//        self.edit_mode = !self.edit_mode
        self.mode.togle()
        //編集モード
//        if self.edit_mode {
//            self.all_select_btn.enabled = true
//            self.setEditBackImage()
//            self.edit_btn.setImage(UIImage(named: "Done"), forState: .Normal)
//            if let tabbarC = self.tabBarController as? RootTabBarController {
//                if let items = tabbarC.tabBar.items as [UITabBarItem]? {
//                    for item : UIBarItem in items {
//                        item.enabled = false
//                    }
//                    tabbarC.button.userInteractionEnabled = false
//                }
//            }
//        }else{
//            self.all_select_btn.enabled = false
//            self.setBackImage()
//            self.edit_btn.setImage(UIImage(named: "edit"), forState: .Normal)
//            if let tabbarC = self.tabBarController as? RootTabBarController {
//                if let items = tabbarC.tabBar.items as [UITabBarItem]? {
//                    for item : UIBarItem in items {
//                        item.enabled = true
//                    }
//                    tabbarC.button.userInteractionEnabled = true
//                }
//            }
//        }
        self.lecCollectionView.reloadData()
    }
    @IBAction func allSelectList(sender: AnyObject) {
        showTimeSlectPopOverViewWithId(nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "myLectures" {
            guard let arr = change?["new"] as? [Lecture] else{ return }
            self.myLectureArray = arr
            
            self.lecCollectionView.reloadData()
        }else if keyPath == "syllabusList" {
            guard let arr = change?["new"] as? [Lecture] else{ return }
            self.syllabusArray  = arr
        }
    }
    
    func showTimeSlectPopOverViewWithId(sender: Int?){
//        popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("PopoverSubjectViewController") as! PopoverSubjectViewController
//        popoverContent.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
//        popoverContent.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext // 背景の透過の設定
//        if sender != nil {
//            popoverContent.tap_index = sender!
//            popoverContent.term = self.term
//        }
//        popoverContent.delegate = self
//        popoverContent.dataArrangement()
//        self.presentViewController(popoverContent, animated: false, completion: nil)
    }
    
    func selected(term: Int) {
//        self.term = term
//        getTimeTableData(term)
    }
    
    func completeMylecture(notification: NSNotification){
//        self.hub.dismiss()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
//        if segue.identifier == "detail" {
//            if let vc = segue.destinationViewController as? TimeTableDetailViewController {
//                self.destinationviewcontroller = vc
//                
//            }
//        }else{
//            if let popupView = segue.destinationViewController as? TermSelectPopOrverTableViewController{
//                if let popup = popupView.popoverPresentationController{
//                    popup.sourceView = sender as! UIView!
//                    popup.sourceRect = sender!.bounds
//                    popup.delegate = self
//                    let popOrverView:TermSelectPopOrverTableViewController = segue.destinationViewController as! TermSelectPopOrverTableViewController
//                    popOrverView.delegate = self
//                    
//                }
//            }
//        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle{
        return UIModalPresentationStyle.None
    }
    
    func termSelectedWithIndexPath(term: Int) {
        getTimeTableData(term)
//        self.term = term
//        setTermTitle(self.term)
        //
        //        let ud = NSUserDefaults.standardUserDefaults()
        //        ud.setObject(String(self.term), forKey: "term")
        //        ud.synchronize()
    }
    
    func setTermTitle(term : Int) {
//        self.term_btn.setTitle(Config_TimeTable.quarterList()[term].semesterName() + "時間割", forState: .Normal)
    }
    
    func getTimeTableData(term : Int) {
//        dispatch_async(dispatch_queue_create(Config.LECTURE_ACYNC_SERIAL, DISPATCH_QUEUE_SERIAL), {
//            self.term = term
//            let mylecArray = MyLectureInfo.getTimeTableData(term)
//            dispatch_async(dispatch_get_main_queue(), {
//                self.myLectureArray = MyLectureInfo.orderlinessArray(mylecArray)
//                self.collectionView.reloadData()
//            })
//        })
    }
    
}

extension LectureCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myLectureArray.count
    }
    //セルの大きさ
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        if indexPath.row == 0 {
            return CGSizeMake(self.lecCollectionView.weekCellWidth,self.lecCollectionView.periodCellHeight)
        }else if indexPath.row > 0 && indexPath.row < LectueModel.HOL_NUM + 1 {
            let w = (CGFloat(self.lecCollectionView.bounds.width - self.lecCollectionView.weekCellWidth ) / CGFloat( LectueModel.HOL_NUM) - self.lecCollectionView.insetBorad * 2 )
            let h = self.lecCollectionView.periodCellHeight
            return CGSizeMake(w, h)
        }else if indexPath.row % ( LectueModel.HOL_NUM + 1 ) == 0 {
            let w = self.lecCollectionView.weekCellWidth
            let h =  (CGFloat(self.lecCollectionView.bounds.height - self.lecCollectionView.periodCellHeight ) / CGFloat( LectueModel.VAR_NUM) - self.lecCollectionView.insetBorad * 2 )
            return CGSizeMake(w, h)        }

        return self.lecCollectionView.collectionViewSize()
    }
    //セルごとの余白
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake( 0, 0, 0, 0 ) // margin between cells
    }
    //左右の等間隔
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    //上下の等間隔
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            return collectionView.dequeueReusableCellWithReuseIdentifier("leftTop", forIndexPath: indexPath)
        }else if indexPath.row > 0 && indexPath.row < LectueModel.HOL_NUM + 1 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("week", forIndexPath: indexPath)
            cell.backgroundColor = UIColor.redColor()
            return cell
        }else if indexPath.row % ( LectueModel.HOL_NUM + 1 ) == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("period", forIndexPath: indexPath)
            cell.backgroundColor = UIColor.orangeColor()
            return cell
        }
        
        guard let cell  = collectionView.dequeueReusableCellWithReuseIdentifier("LectureCollectionViewCell", forIndexPath: indexPath) as? LectureCollectionViewCell else { return UICollectionViewCell() }
        self.lecCollectionView.createLectureCell(cell, mylec: self.myLectureArray[indexPath.row], mode: self.mode, indexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if self.mode == .Edit {
            showTimeSlectPopOverViewWithId(indexPath.row)
        }else{
            let mylec = self.myLectureArray[indexPath.row]
            if !mylec.myLecture {
//                self.performSegueWithIdentifier("detail", sender: self)
//                self.destinationviewcontroller?.lecture = mylec
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        updateFrame()
//        self.headerView.frame.origin = CGPointMake(0, self.collectionView.contentOffset.y + self.header_height.constant)
//        self.sideBar_x.constant = -self.collectionView.contentOffset.y
//        self.sideBar_bottom.constant = SIDEBAR_BOTTOM + self.tabbar_height + self.collectionView.contentOffset.y
    }
    
}
