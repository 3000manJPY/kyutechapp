//
//  NoticeViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 2/6/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//


import UIKit
import RealmSwift
import SHUtil

class NoticeViewController: UIViewController {
    
    @IBOutlet var shContentView: SHContentTableView!
    @IBOutlet var noticeTableView: UITableView!
    var noticeArray: [Notice] = []
    var checkedArray: [Int] = []
    
    var categories: [Category] = []
    var departments: [Department] = []
    
    var detailVC: NoticeDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        self.shContentView.shcontentTableViewInit(self.noticeTableView)
        self.navigationController?.navigationBarHidden = true
        setCategory()
        setDepartment()
        setContentItem()
        self.noticeArray = NoticeModel.sharedInstance.notices
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NoticeModel.sharedInstance.addObserver(self, forKeyPath: "notices", options: [.New, .Old], context: nil)
        self.setRepo()
    }
    
    func setRepo(){
//        let tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: NSStringFromClass(self.classForCoder))
//        
//        let builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NoticeModel.sharedInstance.removeObserver(self, forKeyPath: "notices")

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.shContentView.updateFrame()
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath == "notices"){
            if let arr = change?["new"] as? [Notice] {
            self.noticeArray = arr
                self.noticeTableView.reloadData()
            }
        }
    }
    func setCategory(){     self.categories = CategoryModel.sharedInstance.categorys }
    func setDepartment(){   self.departments = CategoryModel.sharedInstance.departments }
    func setDelegate(){     self.shContentView.delegate = self }
    //segueの決定
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let secondView : NoticeDetailViewController = (segue.destinationViewController as? NoticeDetailViewController ) { self.detailVC = secondView }
    }
    func tapStatusBar(sender: AnyObject?) { self.noticeTableView.setContentOffset(CGPointMake(0, -self.shContentView.contentView.bounds.height - 20), animated: true) }
    func scrollViewDidScroll(scrollView: UIScrollView) { self.shContentView.scrollViewDidScroll(scrollView) }
}

extension NoticeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.noticeArray.count }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell?
        let notice = self.noticeArray[indexPath.row]
        //TODO cellviewを作成
        if let imageView = cell!.viewWithTag(200) as? UIImageView,
            let backView = cell!.viewWithTag(300) as? UIImageView,
            let label    = cell!.viewWithTag(100) as? UILabel {
                for cate in self.categories {
                    
                    if cate.id == Int(notice.categoryId) {
                        backView.image = UIImage(named: cate.imagePath)
                        break
                    }
                }
                for depa in self.departments {
                    if depa.id  == Int(notice.departmentId) {
                        imageView.image = UIImage(named: depa.imagePath)
                        break
                    }
                }
                label.text = notice.title
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.noticeTableView.deselectRowAtIndexPath(indexPath, animated: true)
        //セルがタップされた時
        self.performSegueWithIdentifier("detail", sender: nil)
        let notice = self.noticeArray[indexPath.row]
        self.detailVC?.notice = notice
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat { return 80 }
}

extension NoticeViewController: SHContentTableViewdelegate /*, slidedelegate*/{
    func setContentItem(){
        self.shContentView.title_label.text = "掲示板"
        self.shContentView.category_open.setImage(UIImage(named: "filter"), forState: .Normal)
        self.shContentView.sub_category_open.setImage(UIImage(named: "filter-button"), forState: .Normal)
        self.shContentView.category_open.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.shContentView.search_btn.setImage(UIImage(named: "Refresh_white"), forState: .Normal)
        self.shContentView.search_btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.shContentView.sub_search_btn.setImage(UIImage(named: "reload"), forState: .Normal)
        self.shContentView.sub_search_btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.shContentView.top_image.image = UIImage(named: "top_image")
        self.shContentView.navi_imageview.image = UIImage(named: "news_Ellipse")
    }
    
    func tapRightItem(sender: AnyObject) { NoticeModel.sharedInstance.updateDate() }
    
    func tapLeftItem(sender: AnyObject) { self.frostedViewController.presentMenuViewController() }
    
    func tapViewTop() { self.tapStatusBar(nil) }
}

//メニューがチェックされたら呼ばれる
extension NoticeViewController: CategoryDelegate {
    func checked(dict: [String : Bool]) {
        
        
    }
}
