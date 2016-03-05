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
    var subjectArray  : [(Int,Lecture)] = []
   
    override var preferredContentSize: CGSize {
        get { return CGSize(width: 300, height: 275) }
        set { super.preferredContentSize = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.syllabusArray = LectureModel.sharedInstance.syllabusList
        tableView.registerNib(UINib(nibName: "SubjectTableViewCell", bundle: nil), forCellReuseIdentifier: "SubjectTableViewCell")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.name.text = self.tableView.setTitle(self.tapIndex)
        LectureModel.sharedInstance.addObserver(self, forKeyPath: "syllabusList", options: [.New, .Old], context: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        LectureModel.sharedInstance.removeObserver(self, forKeyPath: "syllabusList")
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "syllabusList" {
            guard let arr = change?["new"] as? [Lecture] else{ return }
            self.syllabusArray  = arr
            self.dataArrangement()
        }
    }
    @IBAction func dismissButton(sender: UIButton) { self.dismissViewControllerAnimated(false, completion: nil) }
    
    @IBAction func deletePushed(sender: UIButton) {
    
    }
    func dataArrangement(){
        self.subjectArray = []
        for (index,item) in self.syllabusArray.enumerate() {
            for subject in item.weekTime.componentsSeparatedByString(",") {
                if subject == self.weekTimeWithTapIndex(self.tapIndex) {
                    self.subjectArray.append((index,item))
                }
            }
        }
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPointZero, animated: false)
    }
    
    func weekTimeWithTapIndex(tapIndex: Int) -> String {
        let week = tapIndex / (LectureModel.HOL_NUM + 1)
        let period = tapIndex % (LectureModel.HOL_NUM + 1)
        return "\(week)\(period)"
    }
    
    @IBAction func nextTap(sender: UIButton) {
        if self.tapIndex + (LectureModel.HOL_NUM + 1) < (LectureModel.VAR_NUM + 1 ) * (LectureModel.HOL_NUM + 1 ) {
            self.tapIndex += (LectureModel.HOL_NUM + 1 )
        }else if self.tapIndex % (LectureModel.HOL_NUM + 1) < LectureModel.HOL_NUM{
            self.tapIndex = (self.tapIndex % (LectureModel.HOL_NUM + 1)) + LectureModel.HOL_NUM + 2
        }
        self.name.text = self.tableView.setTitle(self.tapIndex)
        self.dataArrangement()
    }
    @IBAction func backTap(sender: UIButton) {
        if self.tapIndex - (LectureModel.HOL_NUM + 1) >= (LectureModel.HOL_NUM + 1) {
            self.tapIndex -= (LectureModel.HOL_NUM + 1 )
        }else if self.tapIndex % (LectureModel.HOL_NUM + 1) > 1 {
            self.tapIndex = (self.tapIndex % (LectureModel.HOL_NUM + 1)) + LectureModel.HOL_NUM + (LectureModel.HOL_NUM + 1) * ( LectureModel.VAR_NUM - 1 )
        }
        self.name.text = self.tableView.setTitle(self.tapIndex)
        self.dataArrangement()
    }
}

extension SubjectTableViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("SubjectTableViewCell", forIndexPath: indexPath) as? SubjectTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = UIColor.clearColor()
        let mylec = self.subjectArray[indexPath.row].1
        cell.title.text = mylec.title
        cell.teacher.text = mylec.teacher
        if mylec.myLecture == true {
            cell.checkImageView.hidden = false
        }else{
            cell.checkImageView.hidden = true
        }
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.subjectArray.count }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //===============================================
        let index   = self.subjectArray[indexPath.row].0
        let tapObj  = self.syllabusArray[index]
        let flag    = !tapObj.myLecture
        
        //べつのweektimeにある科目があれば検索してそいつのフラグを消す
        for val in tapObj.weekTime.componentsSeparatedByString(",") {
            if let arr = RealmData.sharedInstance.getMylectureWithWeekTime(val) {
                for item in arr {
                    RealmData.sharedInstance.changeMylecture(item, flag: false)
                }
                
            }
        }
        //選択された科目のフラグを変える
        RealmData.sharedInstance.changeMylecture(self.syllabusArray[index],flag: flag)
        LectureModel.sharedInstance.syllabusList = self.syllabusArray
        
        LectureModel.sharedInstance.updateMylectureDataWithRealm()
        LectureModel.sharedInstance.updateSyllabusDataWithRealm()

    }
    //===============================================移植可能
    

}
