//
//  SubjectTableViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 2/14/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
import RealmSwift
import SHUtil

protocol popoverViewSubjectDelegate{
    func selected(term : Int)
}

class SubjectTableViewController: UIViewController{
    
    @IBOutlet weak var name: UILabel!
//    weak var delegate : TimeTableCollectionViewController?
    @IBOutlet weak var delete_btn: UIButton!
    @IBOutlet weak var tableView: SubjectTableView!
    var tapIndex = 0
//    var term = Term.First.rawValue
    var syllabusArray : [Lecture] = []
    var subjectArray  : [Lecture] = []
   
    override var preferredContentSize: CGSize {
        get { return CGSize(width: 300, height: 275) }
        set { super.preferredContentSize = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.syllabusArray = LectueModel.sharedInstance.syllabusList
        tableView.registerNib(UINib(nibName: "SubjectTableViewCell", bundle: nil), forCellReuseIdentifier: "SubjectTableViewCell")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.name.text = self.tableView.setTitle(self.tapIndex)
        LectueModel.sharedInstance.addObserver(self, forKeyPath: "syllabusList", options: [.New, .Old], context: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        LectueModel.sharedInstance.removeObserver(self, forKeyPath: "syllabusList")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let version = NSString(string: UIDevice.currentDevice().systemVersion).doubleValue
        UITableView.appearance().separatorInset = UIEdgeInsetsZero
        UITableViewCell.appearance().separatorInset = UIEdgeInsetsZero
        if version >= 8 {
            UITableView.appearance().layoutMargins = UIEdgeInsetsZero
            UITableViewCell.appearance().layoutMargins = UIEdgeInsetsZero
        }
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "syllabusList" {
            guard let arr = change?["new"] as? [Lecture] else{ return }
            self.syllabusArray  = arr
            self.dataArrangement()
        }
    }
    @IBAction func dismissButton(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func deletePushed(sender: UIButton) {
    
    }
    func dataArrangement(){
        self.subjectArray = []
        for item in self.syllabusArray {
            for subject in item.week_time.componentsSeparatedByString(",") {
                if subject == self.weekTimeWithTapIndex(self.tapIndex) {
                    self.subjectArray.append(item)
                }
            }
        }
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPointZero, animated: false)
    }
    
    func weekTimeWithTapIndex(tapIndex: Int) -> String {
        let week = tapIndex % (LectueModel.HOL_NUM + 1)
        let period = tapIndex / (LectueModel.HOL_NUM + 1)
        return "\(week)\(period)"
    }
    
    @IBAction func nextTap(sender: UIButton) {
        if self.tapIndex + (LectueModel.HOL_NUM + 1) < (LectueModel.VAR_NUM + 1 ) * (LectueModel.HOL_NUM + 1 ) {
            self.tapIndex += (LectueModel.HOL_NUM + 1 )
        }else if self.tapIndex % (LectueModel.HOL_NUM + 1) < LectueModel.HOL_NUM{
            self.tapIndex = (self.tapIndex % (LectueModel.HOL_NUM + 1)) + LectueModel.HOL_NUM + 2
        }
        self.name.text = self.tableView.setTitle(self.tapIndex)
        self.dataArrangement()
    }
    @IBAction func backTap(sender: UIButton) {
        if self.tapIndex - (LectueModel.HOL_NUM + 1) >= (LectueModel.HOL_NUM + 1) {
            self.tapIndex -= (LectueModel.HOL_NUM + 1 )
        }else if self.tapIndex % (LectueModel.HOL_NUM + 1) > 1 {
            self.tapIndex = (self.tapIndex % (LectueModel.HOL_NUM + 1)) + LectueModel.HOL_NUM + (LectueModel.HOL_NUM + 1) * ( LectueModel.VAR_NUM - 1 )
        }
        self.name.text = self.tableView.setTitle(self.tapIndex)
        self.dataArrangement()
    }
}

extension SubjectTableViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        var cell : popoverViewSubjectTableViewCell!
        //
        guard let cell = tableView.dequeueReusableCellWithIdentifier("SubjectTableViewCell", forIndexPath: indexPath) as? SubjectTableViewCell else { return UITableViewCell() }
        //
        //            cell = val_cell
        cell.backgroundColor = UIColor.clearColor()
        //
        let mylec = self.subjectArray[indexPath.row]
        //
        cell.title.text = mylec.title
        cell.teacher.text = mylec.teacher
        
        if mylec.myLecture == true {
            //                cell.title.textColor = Config_UIColor.themeColor()
            //                cell.teacher.textColor = Config_UIColor.themeColor()
            cell.checkImageView.hidden = false
        }else{
            //                cell.title.textColor = Config_UIColor.grayTextColor()
            //                cell.teacher.textColor = Config_UIColor.grayTextColor()
            cell.checkImageView.hidden = true
        }
        
        //
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subjectArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }

}
