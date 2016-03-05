//
//  NoticeDetailViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 2/6/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//
import UIKit
import TTTAttributedLabel

class LectureDetailTableViewController: UIViewController {
    
//    @IBOutlet weak var tableConstY      : NSLayoutConstraint!
//    @IBOutlet weak var customNaviBar    : UIView!
    var lecture: Lecture?
    @IBOutlet weak var detailTableView: LectureDetailView!
    
    var propatyList = [String:String]()
    var headerTitle                     : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPropatyList()
        self.title = self.propatyList["科目名"]
        self.detailTableView.reloadData()
    }

   
}

extension LectureDetailTableViewController: UITableViewDataSource, UITableViewDelegate, TTTAttributedLabelDelegate {
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
        guard let lecture = self.lecture else { return }
        for propaty in lecture.propatyList() {
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
