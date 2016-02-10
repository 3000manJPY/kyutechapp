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
    
    @IBOutlet var shContentView: NoticeView!
    @IBOutlet weak var noticeTableView: NoticeTableView!
    var noticeArray : [Notice]      = []
    var categories  : [Sort]  = []
    var departments : [Sort]  = []
    var orders      : [Sort]  = []
    
    var detailVC: NoticeDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        self.shContentView.shcontentTableViewInit(self.noticeTableView)
        self.navigationController?.navigationBarHidden = true
        
        (self.categories, self.departments, self.orders) = MenuModel.sharedInstance.getMenuArrays()
        self.shContentView.setContentItem()
        self.noticeArray = NoticeModel.sharedInstance.notices
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NoticeModel.sharedInstance.addObserver(self, forKeyPath: "notices", options: [.New, .Old], context: nil)
        MenuModel.sharedInstance.addObserver(self, forKeyPath: "menus", options: [.New, .Old], context: nil)
        self.setRepo()
    }
    //googleAnariticsを設定
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
        MenuModel.sharedInstance.removeObserver(self, forKeyPath: "menus")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.shContentView.updateFrame()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "notices" {
            guard let arr = change?["new"] as? [Notice] else{ return }
            self.noticeArray = arr
            self.noticeTableView.reloadData()
        }else if keyPath == "menus" {
            var cate: [Sort] = [], depa: [Sort] = [], order: Sort? = nil
            guard let arr = change?["new"] as? [Sort] else{ return }
            NoticeModel.sharedInstance.tmpArray = []
            for menu in arr {
                if menu.menu == .category { cate.append(menu) }
                if menu.menu == .department { depa.append(menu) }
                if menu.menu == .order && menu.check == true { order = menu }
            }
                //カテゴリーフィルターする
                NoticeModel.sharedInstance.filterCategory(cate)
                //ジャンルフィルターする
                NoticeModel.sharedInstance.filterDetartment(depa)
                 NoticeModel.sharedInstance.sortData(order)
            
        }
    }
    func setDelegate(){ self.shContentView.delegate = self }
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
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let notice = self.noticeArray[indexPath.row]
        cell = self.noticeTableView.createCell(cell, notice: notice)
        return cell
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
    func tapRightItem(sender: AnyObject) { NoticeModel.sharedInstance.updateDate() }
    func tapLeftItem(sender: AnyObject) { self.frostedViewController.presentMenuViewController() }
    func tapViewTop() { self.tapStatusBar(nil) }
}

