//
//  NoticeDetailViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 2/6/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

//
//  NoticeDetailViewController.swift
//  kyutechapp
//
//  Created by 岡室 庄悟 on 7/3/15.
//  Copyright (c) 2015 岡室 庄悟. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class NoticeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TTTAttributedLabelDelegate {
    
    @IBOutlet weak var tableConstY: NSLayoutConstraint!
    @IBOutlet weak var customNaviBar: UIView!
    var notice: Notice?
    @IBOutlet weak var detailTableView: UITableView!
    var propatyList = [String:String]()
    var headerTitle: [String] = []
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let _ = self.navigationController {
            self.customNaviBar.hidden = true
            self.tableConstY.constant = -self.customNaviBar.bounds.height
        }else{
            self.customNaviBar.hidden = false
        }
        
        self.detailTableView.estimatedRowHeight = 90
        self.detailTableView.rowHeight = UITableViewAutomaticDimension
        //        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.setupTableView()
        self.setPropatyList()
        self.title = self.propatyList["カテゴリー"]
        self.detailTableView.reloadData()
    }
    
    //*************************************
    //viewWillAppear
    //*************************************
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
        
//        self.navigationController?.slideMenuController()?.removeLeftGestures()
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.hidden = false
        
//        self.navigationController?.slideMenuController()?.removeLeftGestures()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.hidden = true
    }
   
    
    func setupTableView(){
        //        self.tableView.registerNib(UINib(nibName: "NoticeDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) //as? UITableViewCell
        //let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? NoticeDetailTableViewCell
        let key = String(self.headerTitle[indexPath.section])
        let label = cell.viewWithTag(100) as? TTTAttributedLabel
        label?.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
        // urlをタップされたときになにか処理する場合(Webビューやブラウザを起動したり)
        label?.delegate = self
        label?.text = self.propatyList[key]
        cell.layoutIfNeeded()
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.propatyList.count
    }
    
    func setPropatyList(){
        guard let notice = self.notice else {
            
            return
        }
        for propaty in notice.propatyList() {
            guard let val = propaty.first else { continue }
            self.propatyList[val.0] = val.1
            self.headerTitle.append(val.0)
        }
    }
    
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //            let widthOfScreen = UIScreen.mainScreen().bounds.width
    //            return widthOfScreen / 3
    //    }
    //    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 50
    //    }
    
    // セクションヘッダのビュー取得
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width , 22))
        headerView.backgroundColor = section % 2 == 0 ? UIColor(colorLiteralRed: 0, green: 138.0 / 255.0 , blue: 215.0 / 255.0 , alpha: 1.0) : UIColor(colorLiteralRed: 107.0 / 255.0 , green: 179.0 / 255.0 , blue: 220.0 / 255.0 , alpha: 1.0)
        let header = UILabel(frame: CGRectMake(5, 0, self.view.bounds.size.width, 27))
        header.backgroundColor = UIColor.whiteColor()
        header.text = String(self.headerTitle[section])
        
        headerView.addSubview(header)
        return headerView
    }
    
    // urlリンクをタップされたときの処理を記述します
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!)
    {
        if UIApplication.sharedApplication().canOpenURL(url!){
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}