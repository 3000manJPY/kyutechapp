//
//  NoticeViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 2/6/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//


import UIKit

import Alamofire
import RealmSwift
import SHUtil

class NoticeViewController: UIViewController , UITableViewDataSource , UITableViewDelegate, SHContentTableViewdelegate /*, slidedelegate*/{
    
    @IBOutlet var shContentView: SHContentTableView!
    @IBOutlet var noticeTableView: UITableView!
    
    
    var noticeArray : [Notice] = []
    var searchArray : [Notice] = []
    var originArry : [Notice] = []
    
    var checkedArray : [Int] = []
    
    var is_load = false
    
    
    
//    var categoryArray : [Category] = []
//    var departmentArray : [Department] = []
    
    //    var destinationVC : SHWebViewController!
    var destinationVC : NoticeDetailViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        self.shContentView.shcontentTableViewInit(self.noticeTableView)
        self.navigationController?.navigationBarHidden = true
//        self.navigationController?.slideMenuController()?.addLeftGestures()
        
        setCategory()
        setDepartment()
        setContentItem()
        updateData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        let tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: NSStringFromClass(self.classForCoder))
//        
//        let builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])
        
        //        self.navigationController?.navigationBarHidden = true
//        self.navigationController?.slideMenuController()?.addLeftGestures()
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.shContentView.updateFrame()
        
    }
    
    func setCategory(){
//        self.categoryArray = Config_Category.setCategory()
        
    }
    
    func setDepartment(){
//        self.departmentArray = Config_Category.setDepartment()
        
    }
    
    func setDelegate(){
//        self.navigationController?.slideMenuController()?.delegate = self
        self.shContentView.delegate = self
    }
    
    func setContentItem(){
        //本番は画像の予定
        self.shContentView.title_label.text = "掲示板"
        self.shContentView.category_open.setImage(UIImage(named: "filter"), forState: .Normal)
        self.shContentView.sub_category_open.setImage(UIImage(named: "filter-button"), forState: .Normal)
        self.shContentView.category_open.setTitleColor(UIColor.blackColor(), forState: .Normal)
        //        self.contentView.search_btn.setTitle("○", forState: .Normal)
        self.shContentView.search_btn.setImage(UIImage(named: "Refresh_white"), forState: .Normal)
        self.shContentView.search_btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.shContentView.sub_search_btn.setImage(UIImage(named: "reload"), forState: .Normal)
        self.shContentView.sub_search_btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        self.shContentView.top_image.image = UIImage(named: "top_image")
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noticeArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell?
        
        let notice = noticeArray[indexPath.row]
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        //TODO cellviewを作成
//        let imageView = cell!.viewWithTag(10) as! UIImageView
//        let backView = cell!.viewWithTag(9) as! UIImageView
//        for cate in self.categoryArray {
//            //            if cate.id < 2 && cate.id > 11 {
//            //                backView.image = UIImage(named: cate.image_path)
//            //                break
//            //
//            //            }
//            //            else
//            if cate.id == Int(notice.category_id) {
//                backView.image = UIImage(named: cate.image_path)
//                break
//            }
//        }
//        
//        for depa in self.departmentArray {
//            if depa.id  == Int(notice.department_id) {
//                imageView.image = UIImage(named: depa.image_path)
//                
//                break
//            }
//        }
        
        let label = cell!.viewWithTag(11) as! UILabel
        label.text = notice.title
        
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.noticeTableView.deselectRowAtIndexPath(indexPath, animated: true)
        //セルがタップされた時
        //        self.performSegueWithIdentifier("webView", sender: nil)//
        self.performSegueWithIdentifier("detail", sender: nil)
        
        let notice = self.noticeArray[indexPath.row]
//        self.destinationVC.notice = notice
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        !!old-webView!!
        if let secondView : SHWebViewController = (segue.destinationViewController as? SHWebViewController) {
        self.destinationVC = secondView
        }
        
        */
        if let secondView : NoticeDetailViewController = (segue.destinationViewController as? NoticeDetailViewController ) {
            self.destinationVC = secondView
        }
        
        
        
        
    }
    
    internal func openSlideView(sender: AnyObject) {
//        self.navigationController?.slideMenuController()?.openLeft()
    }
    
    func slideClosed(array: [String]) {
        //        println(array)
    }
    
    func tapStatusBar(sender: AnyObject?) {
        self.noticeTableView.setContentOffset(CGPointMake(0, -self.shContentView.contentView.bounds.height - 20), animated: true)
    }
    
    func selected(index: Int) {
        //        println(index)
        //        if let num_index = self.checkedArray.find({ $0 == index }) {
        if let num_index = self.checkedArray.indexOf({$0 == index}){
            //            println(num_index)
            self.checkedArray.removeAtIndex(num_index)
        }else{
            self.checkedArray.append(index)
            
        }
        
        self.sort()
    }
    
    func sort(){
//        
//        let array = NoticeInfo.filterWithRownumber(self.checkedArray, originArray: self.originArry)
//        self.noticeArray = NoticeInfo.finishTimeSortWithArray(array)
//        self.tableView.reloadData()
        
    }
    
    internal func tapImage(sender: UIButton){
        //        var tag = sender.tag
        //        self.news_delegate?.performSegueWithIdentifier("activeHome", sender: tag)
        
        
    }
    
    func tapRightItem(sender: AnyObject) {
//        
//        if self.is_load {
//            
//        }else{
//            //        println("search")
//            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//                
//                NoticeInfo.siteInfo { (tobata,iizuka,wakamatsu, error) in
//                    let orderArray = NoticeInfo.finishTimeSortWithArray(iizuka)
//                    
//                    self.noticeArray = orderArray
//                    self.originArry = orderArray
//                    self.sort()
//                    self.is_load = false
//                }
//            })
//            self.is_load = true
//        }
    }
    
    func tapLeftItem(sender: AnyObject) {
//        self.navigationController?.slideMenuController()?.openLeft()
    }
    
    func tapViewTop() {
        self.tapStatusBar(nil)
    }
    
    func updateData(){
//        NoticeInfo.siteInfo { (itobata,iizuka,wakamatsu, error) in
//            self.timeSortWithArray(iizuka)
//        }
    }
    
    func timeSortWithArray(array : [Notice]){
//        let orderArray = NoticeInfo.finishTimeSortWithArray(array)
//        
//        self.noticeArray = orderArray
//        self.originArry = orderArray
//        self.tableView.reloadData()
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        self.shContentView.scrollViewDidScroll(scrollView)
        
    }
}
