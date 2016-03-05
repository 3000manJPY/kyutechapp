//
//  LectureCollectionView.swift
//  kyutech
//
//  Created by shogo okamuro on 2/11/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

class LectureCollectionView: UICollectionView {
    
    let insetBorad = CGFloat(1.01) // セル左右の余白の太さ
    let weekCellWidth = CGFloat(50)
    let periodCellHeight = CGFloat(50)
    
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
   
    func createCollectionViewCell(lec: Lecture, mode: LECTUREMODE, indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            return self.dequeueReusableCellWithReuseIdentifier("leftTop", forIndexPath: indexPath)
        }else if indexPath.row > 0 && indexPath.row < LectureModel.HOL_NUM + 1 {
            let cell = self.dequeueReusableCellWithReuseIdentifier("week", forIndexPath: indexPath)
            return cell.createLeftWeekCell(indexPath)
        }else if indexPath.row % ( LectureModel.HOL_NUM + 1 ) == 0 {
            let cell = self.dequeueReusableCellWithReuseIdentifier("period", forIndexPath: indexPath)
            return cell.createperiodCell(indexPath)
        }else{
            guard let cell  = self.dequeueReusableCellWithReuseIdentifier("LectureCollectionViewCell", forIndexPath: indexPath) as? LectureCollectionViewCell else { return UICollectionViewCell() }
            return cell.createLectureCell(lec, mode: mode, indexPath: indexPath)
        }
        
        
    }
    func collectionViewSize(indexPath: NSIndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSizeMake(self.weekCellWidth,self.periodCellHeight)
        }else if indexPath.row > 0 && indexPath.row < LectureModel.HOL_NUM + 1 {
            let w = (CGFloat(self.bounds.width - self.weekCellWidth ) / CGFloat( LectureModel.HOL_NUM) - self.insetBorad * 2 )
            let h = self.periodCellHeight
            return CGSizeMake(w, h)
        }else if indexPath.row % ( LectureModel.HOL_NUM + 1 ) == 0 {
            let w = self.weekCellWidth
            let h =  (CGFloat(self.bounds.height - self.periodCellHeight ) / CGFloat( LectureModel.VAR_NUM) - self.insetBorad * 2 )
            return CGSizeMake(w, h)
        }else{
            let w = (CGFloat(self.bounds.width - self.weekCellWidth ) / CGFloat( LectureModel.HOL_NUM) - self.insetBorad * 2 )
            let h =  (CGFloat(self.bounds.height - self.periodCellHeight ) / CGFloat( LectureModel.VAR_NUM) - self.insetBorad * 2 )
            return CGSizeMake(w, h)
        }
    }
    
}



