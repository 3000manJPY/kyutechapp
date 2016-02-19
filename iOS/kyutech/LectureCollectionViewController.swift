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
    
    var mode = LECTUREMODE.Normal
    
//    var popoverContent:PopoverSubjectViewController!
    
    @IBOutlet weak var centerBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var allSelectBtn: UIButton!
    @IBOutlet weak var lecCollectionView: LectureCollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allSelectBtn.enabled = false
        
        guard let titleWidth = self.centerBtn.titleLabel?.bounds.size.width,
              let imageWidth = self.centerBtn.imageView?.bounds.size.width else { return }
        self.centerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth)
        self.centerBtn.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth,  0, -titleWidth)
        
        self.lecCollectionView.registerNib(UINib(nibName: "LectureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LectureCollectionViewCell")
       
        self.myLectureArray = LectueModel.sharedInstance.myLectures

        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        LectueModel.sharedInstance.addObserver(self, forKeyPath: "myLectures", options: [.New, .Old], context: nil)
//        let tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: NSStringFromClass(self.classForCoder))
//        
//        let builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        LectueModel.sharedInstance.removeObserver(self, forKeyPath: "myLectures")
    }
    
    @IBAction func editModePushed(sender: AnyObject) {
        self.mode.togle()
        self.lecCollectionView.reloadData()
    }
    @IBAction func allSelectList(sender: AnyObject) {
//        showTimeSlectPopOverViewWithId(nil)
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
    
    func showTimeSlectPopOverViewWithId(index: Int){
        guard let popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("SubjectTableViewController") as? SubjectTableViewController else { return }
        popoverContent.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext // 背景の透過の設定
//        popoverContent.delegate = self
        popoverContent.tapIndex = index
        popoverContent.dataArrangement()
        self.presentViewController(popoverContent, animated: false, completion: nil)
    }
    
    func selected(term: Int) {
//        self.term = term
//        getTimeTableData(term)
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
        return self.lecCollectionView.collectionViewSize(indexPath)
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
        return self.lecCollectionView.createCollectionViewCell(self.myLectureArray[indexPath.row], mode: self.mode, indexPath:indexPath)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < LectueModel.HOL_NUM || indexPath.row % (LectueModel.HOL_NUM + 1) == 0 { return }
        if self.mode == .Edit {
            self.showTimeSlectPopOverViewWithId(indexPath.row)
        }else{
            let mylec = self.myLectureArray[indexPath.row]
            if !mylec.myLecture {
//                self.performSegueWithIdentifier("detail", sender: self)
//                self.destinationviewcontroller?.lecture = mylec
            }
        }
    }
}

extension LectureCollectionViewController :UIPopoverPresentationControllerDelegate ,TermPopOrverDelegate{
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .None
    }
    func prepareForPopoverPresentation(popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.permittedArrowDirections = .Any
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
//            if let vc = segue.destinationViewController as? TimeTableDetailViewController {
//                self.destinationviewcontroller = vc
//                
//            }
            
        }else{
            let popView = segue.destinationViewController
            guard let popup = popView.popoverPresentationController,
                let popSender = sender else{ return }
            popup.sourceView = popSender as? UIView
            popup.sourceRect = popSender.bounds
            popup.delegate = self
            if let popOrverView:TermTableViewController = segue.destinationViewController as? TermTableViewController {
                popOrverView.delegate = self
            }
        }
    }
    func termSelectedWithIndexPath(term: Int) {
        //        getTimeTableData(term)
                self.setTermTitle(term)
        //
        //        let ud = NSUserDefaults.standardUserDefaults()
        //        ud.setObject(String(self.term), forKey: "term")
        //        ud.synchronize()
    }
    
    func setTermTitle(term : Int) {
        self.centerBtn.setTitle(Term()[term], forState: .Normal)
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

