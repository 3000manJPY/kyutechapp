//
//  NoticeDetailViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 2/6/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//
import UIKit
import TTTAttributedLabel

class NoticeDetailViewController: UIViewController {
    
    @IBOutlet weak var tableConstY      : NSLayoutConstraint!
    @IBOutlet weak var customNaviBar    : UIView!
    var notice: Notice?
    @IBOutlet weak var detailTableView: NoticeDetailView!
    
    var propatyList = [String:String]()
    var headerTitle                     : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavibar()
        self.setPropatyList()
        self.title = self.propatyList["カテゴリー"]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.detailTableView.reloadData()
    }
    func setNavibar(){
        if let _ = self.navigationController {
            self.customNaviBar.hidden = true
//            self.tableConstY.constant = -self.customNaviBar.bounds.height
        }else{
            self.customNaviBar.hidden = false
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.hidden = false
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.hidden = true
    }
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension NoticeDetailViewController: UITableViewDataSource, UITableViewDelegate, TTTAttributedLabelDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let key = String(self.headerTitle[indexPath.section])
        let label = cell.viewWithTag(100) as? TTTAttributedLabel
        label?.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
        label?.delegate = self
        label?.text = self.propatyList[key]
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return self.propatyList.count }
    func setPropatyList(){
        guard let notice = self.notice else { return }
        for propaty in notice.propatyList() {
            guard let val = propaty.first else { continue }
            self.propatyList[val.0] = val.1
            self.headerTitle.append(val.0)
        }
    }
    
    // セクションヘッダのビュー取得
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return self.detailTableView.createHeadView(section, title: String(self.headerTitle[section])) }
    // urlリンクをタップされたとき
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!){ if UIApplication.sharedApplication().canOpenURL(url!){ UIApplication.sharedApplication().openURL(url!) } }
}