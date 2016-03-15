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
    var mode = LECTUREMODE.Normal
    var destinationviewcontroller: LectureDetailTableViewController?
    var isCahngeCampus = false
    
    @IBOutlet weak var centerBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var allSelectBtn: UIButton!
    @IBOutlet weak var lecCollectionView: LectureCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allSelectBtn.enabled = false
        self.setCenterBtn()
        self.lecCollectionView.registerNib(UINib(nibName: "LectureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LectureCollectionViewCell")
        self.myLectureArray = LectureModel.sharedInstance.myLectures
       
        let term = NSUserDefaults.standardUserDefaults().integerForKey(Config.userDefault.term)
        self.setTermTitle(term)
        self.setReceiveObserver()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        LectureModel.sharedInstance.addObserver(self, forKeyPath: "myLectures", options: [.New, .Old], context: nil)
//        let tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: NSStringFromClass(self.classForCoder))
//        
//        let builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])
        
        
        if self.isCahngeCampus {
            LectureModel.sharedInstance.settingData()
            LectureModel.sharedInstance.updateMylectureDataWithRealm()
 
            self.isCahngeCampus = false
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        LectureModel.sharedInstance.removeObserver(self, forKeyPath: "myLectures")
    }
    
    func setCenterBtn() {
        guard let titleWidth = self.centerBtn.titleLabel?.bounds.size.width,
              let imageWidth = self.centerBtn.imageView?.bounds.size.width else { return }
        self.centerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth)
        self.centerBtn.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth,  0, -titleWidth)
    }
    
    @IBAction func editModePushed(sender: AnyObject) {
        self.mode.togle()
        if self.mode == .Normal {
            self.allSelectBtn.enabled = false
        }else if self.mode == .Edit {
            self.allSelectBtn.enabled = true
        }
        self.lecCollectionView.reloadData()
    }
    @IBAction func allSelectList(sender: AnyObject) {
//        showTimeSlectPopOverViewWithId(nil)
        self.showTimeSlectPopOverViewWithId(0)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "myLectures" {
            guard let arr = change?["new"] as? [Lecture] else{ return }
            self.myLectureArray = arr
            self.lecCollectionView.reloadData()
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
    //
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int { return 1 }
    //
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return myLectureArray.count }
    //セルの大きさ
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{ return self.lecCollectionView.collectionViewSize(indexPath) }
    //セルごとの余白
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets { return UIEdgeInsetsMake( 0, 0, 0, 0 ) }
    //左右の等間隔
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat { return 2 }
    //上下の等間隔
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat { return 2 }
    //最小間隔
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.lecCollectionView.createCollectionViewCell(self.myLectureArray[indexPath.row], mode: self.mode, indexPath:indexPath)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < LectureModel.HOL_NUM || indexPath.row % (LectureModel.HOL_NUM + 1) == 0 { return }
        if self.mode == .Edit {
            self.showTimeSlectPopOverViewWithId(indexPath.row)
        }else{
            let mylec = self.myLectureArray[indexPath.row]
            if mylec.myLecture {
                self.performSegueWithIdentifier("detail", sender: self)
                self.destinationviewcontroller?.lecture = mylec
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
            self.goToLectureDetailTableViewController(segue)
        }else{
            self.goToTermTableViewController(segue, sender: sender)
        }
    }
    
    func goToLectureDetailTableViewController(segue: UIStoryboardSegue){
        guard let vc = segue.destinationViewController as? LectureDetailTableViewController else{ return }
        self.destinationviewcontroller = vc
    }
    
    func goToTermTableViewController(segue: UIStoryboardSegue, sender: AnyObject?) {
        let popView = segue.destinationViewController
        guard let popup = popView.popoverPresentationController,
            let popSender = sender else{ return }
        popup.sourceView = popSender as? UIView
        popup.sourceRect = popSender.bounds
        popup.delegate = self
        guard let popOrverView:TermTableViewController = segue.destinationViewController as? TermTableViewController else{ return }
        popOrverView.delegate = self
        
    }

    func termSelectedWithIndexPath(term: Int) {
        self.setTermTitle(term)
        LectureModel.sharedInstance.updateMylectureDataWithRealm()
       
    }
    
    func setTermTitle(term : Int) {
        self.centerBtn.setTitle(Term()[term], forState: .Normal)
    }
    
}

extension LectureCollectionViewController: KyutechDelagate {
    func setReceiveObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeCampus:", name: Config.notification.changeCampus, object: nil)
        
    }
    
    func changeCampus(notification: NSNotification?) {
        self.isCahngeCampus = true
    }
}


