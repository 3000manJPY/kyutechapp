//
//  LectureCollectionView.swift
//  kyutech
//
//  Created by shogo okamuro on 2/11/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

class LectureCollectionView: UICollectionView {
    
    
//    let SIDEBAR_WIDTH = CGFloat(40)
//    let SIDEBAR_BOTTOM = CGFloat(100)
//   var myLectureArray : [Lecture] = []
    
//   
//    @IBOutlet weak var header_y: NSLayoutConstraint!
//    @IBOutlet weak var header_height: NSLayoutConstraint!
//    @IBOutlet weak var heder_image_x: NSLayoutConstraint!
//    
//    @IBOutlet weak var sideBar_y: NSLayoutConstraint!
//    @IBOutlet weak var sideBar_bottom: NSLayoutConstraint!
//    @IBOutlet weak var sideBar_width: NSLayoutConstraint!
//    @IBOutlet weak var sideBar_x: NSLayoutConstraint!
//    
//    @IBOutlet weak var week_imageView: UIImageView!
//    @IBOutlet weak var period_imageView: UIImageView!
    
    let insetBorad = CGFloat(1.01) // セル左右の余白の太さ
    let weekCellWidth = CGFloat(50)
    let periodCellHeight = CGFloat(50)
    
//    let tabbar_height = CGFloat(50.0)
    
    
//    @IBOutlet weak var sideBarView: UIView!
//    @IBOutlet weak var headerView: UIView!
//    @IBOutlet weak var all_select_btn: UIButton!
//    
//    @IBOutlet weak var edit_btn: UIButton!
//    
//    var edit_mode = false
//    @IBOutlet weak var navi_bar: UINavigationItem!
//    @IBOutlet weak var term_btn: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
                self.backgroundColor = UIColor(red: 230.0 / 255.0, green: 230.0 / 255.0, blue: 230.0 / 255.0, alpha: 1.0)
//        self.myLectureArray = LectueModel.sharedInstance.lectures
//                LectueModel.sharedInstance.addObserver(self, forKeyPath: "lectures", options: [.New, .Old], context: nil)
    }
    
//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        if keyPath == "lectures" {
//            guard let arr = change?["new"] as? [Lecture] else{ return }
//            self.myLectureArray = arr
//        }
//    }
    func setCollectionViewInset(){
//        let edgeInsets = UIEdgeInsetsMake(self.header_y.constant + self.header_height.constant,self.sideBar_width.constant , 0, 0)
//        self.contentInset = edgeInsets
//        self.scrollIndicatorInsets = edgeInsets
    }
    func updateFrame(){
//        self.sideBar_width.constant = SIDEBAR_WIDTH
//        self.heder_image_x.constant = SIDEBAR_WIDTH
    }
    
    func setEditBackImage(){
//        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
//            self.week_imageView.image = UIImage(named: "week(edit)")
//            self.period_imageView.image = UIImage(named: "period(edit)")
//        }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
//            self.week_imageView.image = UIImage(named: "iPadWeek(edit)")
//            self.period_imageView.image = UIImage(named: "iPadPeriod(edit)")
//        }else{
//            
//        }
    }
    
    func setBackImage(){
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
//            self.week_imageView.image = UIImage(named: "week(main)")
//            self.period_imageView.image = UIImage(named: "period(main)")
//            
//        }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
//            self.week_imageView.image = UIImage(named: "iPadWeek(main)")
//            self.period_imageView.image = UIImage(named: "iPadPeriod(main)")
//        }else{
//            
        }
    }
    
    func setCellImage(cell: LectureCollectionViewCell) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            cell.backgroundImageView.image = UIImage(named: "tt(main)-cell")
            cell.roomImageView.image = UIImage(named: "tt(main)-room")
        }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
            cell.backgroundImageView.image = UIImage(named: "iPadTt(main)-cell")
            cell.roomImageView.image = UIImage(named: "iPadTt(main)-room")
        }else{
            
        }
    }
    
    func setEditCellImage(cell: LectureCollectionViewCell) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            cell.backgroundImageView.image = UIImage(named: "tt(edit)-cell")
            cell.roomImageView.image = UIImage(named: "tt(edit)-room")
        }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
            cell.backgroundImageView.image = UIImage(named: "iPadTt(edit)-cell")
            cell.roomImageView.image = UIImage(named: "iPadTt(edit)-room")
        }else{
            
        }
    }
    
    func setNonEditCellImage(cell: LectureCollectionViewCell) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            cell.backgroundImageView.image = UIImage(named: "non")
            cell.roomImageView.image = nil
        }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
            cell.backgroundImageView.image = UIImage(named: "iPadNon")
            cell.roomImageView.image = nil
        }else{
            
        }
    }
    
    func createLectureCell(cell: LectureCollectionViewCell, mylec: Lecture, mode: LECTUREMODE, indexPath: NSIndexPath){
        cell.room.adjustsFontSizeToFitWidth = true
        cell.room.minimumScaleFactor = 0.8
        cell.title.text = mylec.title
        cell.room.text = mylec.teacher
        //変種モード
        if mode == .Edit {
            cell.backgroundColor = UIColor.whiteColor()
//            if mylec.title != "" {
            if !mylec.myLecture {
                self.setEditCellImage(cell)
            }else{
                self.setNonEditCellImage(cell)
            }
        }else if mode == .Normal {
            cell.backgroundColor = UIColor.whiteColor()
            cell.layer.shadowOpacity = 0 /* 透明度 */
//            if mylec.title != "" {
            if true {
                cell.room.text = mylec.room
                self.setCellImage(cell)
            }else{
                cell.backgroundImageView.image = nil
                cell.roomImageView.image = nil
            }
        }

    }
    
    func collectionViewSize() -> CGSize {
//        let width = ( self.bounds.width - CGFloat( LectueModel.HOL_NUM ) * self.insetBorad ) / CGFloat( LectueModel.HOL_NUM + 1)
//        let height = ( self.bounds.height - self.header_height.constant - SIDEBAR_BOTTOM + 4.0 ) / CGFloat( self.VAR_NUM )
//        let height = ( self.bounds.height + 4.0 ) / CGFloat( LectueModel.VAR_NUM + 1 )
        let w = (CGFloat(self.bounds.width - self.weekCellWidth ) / CGFloat( LectueModel.HOL_NUM) - self.insetBorad * 2 )
        let h =  (CGFloat(self.bounds.height - self.periodCellHeight ) / CGFloat( LectueModel.VAR_NUM) - self.insetBorad * 2 )
        
        return CGSizeMake(w, h)
    }
    
}



