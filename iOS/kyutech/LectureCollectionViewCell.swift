//
//  LectureCollectionViewCell.swift
//  kyutech
//
//  Created by shogo okamuro on 2/11/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
import SHUtil

class LectureCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var roomImageView: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var room: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func createLectureCell(mylec: Lecture, mode: LECTUREMODE, indexPath: NSIndexPath) -> UICollectionViewCell{
        self.room.adjustsFontSizeToFitWidth = true
        self.room.minimumScaleFactor = 0.8
        self.title.text = mylec.title
        self.room.text = mylec.teacher
        //変種モード
        if mode == .Edit {
            self.backgroundColor = UIColor.whiteColor()
            //            if mylec.title != "" {
            if !mylec.myLecture {
                self.setEditCellImage()
            }else{
                self.setNonEditCellImage()
            }
        }else if mode == .Normal {
            self.backgroundColor = UIColor.whiteColor()
            self.layer.shadowOpacity = 0 /* 透明度 */
            //            if mylec.title != "" {
            if true {
                self.room.text = mylec.room
                self.setCellImage()
            }else{
                self.backgroundImageView.image = nil
                self.roomImageView.image = nil
            }
        }
        return self
    }
    func setCellImage() {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.backgroundImageView.image = UIImage(named: "tt(main)-cell")
            self.roomImageView.image = UIImage(named: "tt(main)-room")
        }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
            self.backgroundImageView.image = UIImage(named: "iPadTt(main)-cell")
            self.roomImageView.image = UIImage(named: "iPadTt(main)-room")
        }else{
            
        }
    }
    
    func setEditCellImage() {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.backgroundImageView.image = UIImage(named: "tt(edit)-cell")
            self.roomImageView.image = UIImage(named: "tt(edit)-room")
        }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
            self.backgroundImageView.image = UIImage(named: "iPadTt(edit)-cell")
            self.roomImageView.image = UIImage(named: "iPadTt(edit)-room")
        }else{
            
        }
    }
    
    func setNonEditCellImage() {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.backgroundImageView.image = UIImage(named: "non")
            self.roomImageView.image = nil
        }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
            self.backgroundImageView.image = UIImage(named: "iPadNon")
            self.roomImageView.image = nil
        }else{
            
        }
    }
}

extension UICollectionViewCell {
    func createLeftWeekCell(indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let week = self.viewWithTag(100) as? UILabel else{ return self }
        week.text = self.WeekValueWithIndexPath(indexPath)
        return self
    }
    
    func createperiodCell(indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let period = self.viewWithTag(200) as? UILabel else{ return self }
        period.text = String(indexPath.row / (LectueModel.HOL_NUM + 1))
        return self
    }
    
    func WeekValueWithIndexPath(indexPath: NSIndexPath) -> String {
        switch indexPath.row {
        case 1: return WEEKS.Monday.name()
        case 2: return WEEKS.Tuesday.name()
        case 3: return WEEKS.Wednesday.name()
        case 4: return WEEKS.Thursday.name()
        case 5: return WEEKS.Friday.name()
        default: return ""
        }
    }
    
}

