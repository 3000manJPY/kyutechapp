//
//  LectureModel.swift
//  kyutech
//
//  Created by shogo okamuro on 2/11/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
import Alamofire
import SHUtil

class LectureModel: NSObject {
    class   var sharedInstance: LectureModel { struct Singleton { static let instance: LectureModel = LectureModel() }; return Singleton.instance }
    static  let HOL_NUM = 5
    static  let VAR_NUM = 6
    dynamic var myLectures   :[Lecture] = []
    dynamic var syllabusList :[Lecture] = []
    private var requestState :RequestState = .None {
        willSet {
            switch  newValue {
            case .None, .Error :
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            case .Requesting :
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            }
        }
    }
    
    private override init() {
        super.init()
        self.settingData()
        self.setMylectureDataWithRealm()
        self.setSyllabusDataWithRealm()
    }
    
    func settingData(){
        self.reqestLectures(CAMPUS.iizuka.val) { (lectures) -> () in
            if lectures.count <= 0 { return }
            //TODO: 全削除してから登録しなおさんといかんクネ？=========================================
            RealmData.sharedInstance.save(lectures)
            self.setsyllabusData(lectures)
            self.setMylectureData(lectures)
            
        }
    }
   
    private func reqestLectures(campus: Int, completion: ([Lecture]) -> ()){
        if self.requestState == .Requesting { return }
        APIService.reqestLectures(campus, completionHandler: { (lectures) -> () in
            self.requestState = .None
            completion(lectures)
            }) { (type, code) -> () in
                self.requestState = .Error
        }
    }
    
    private func setSyllabusDataWithRealm(){
       guard let arr = RealmData.sharedInstance.getMyLectureData() else{ return }
        self.setsyllabusData(arr)
    }
    
    func updateSyllabusDataWithRealm(){
        guard let arr = RealmData.sharedInstance.getMyLectureData() else{ return }
        LectureModel.sharedInstance.syllabusList = arr
    }
    
    private func setsyllabusData(arr: [Lecture]){
        self.syllabusList = arr
 
    }
    
    private func setMylectureDataWithRealm(){
        guard let arr = RealmData.sharedInstance.getMyLectureData() else{ return }
        self.setMylectureData(arr)
    }
    
    private func setMylectureData(arr: [Lecture]){
        self.myLectures = self.mylectureAnal(arr)
 
    }
    
    func updateMylectureDataWithRealm(){
        guard let arr = RealmData.sharedInstance.getMyLectureData() else{ return }
        LectureModel.sharedInstance.myLectures = self.mylectureAnal(arr)
    }
    
    private func mylectureAnal(arr: [Lecture]) -> [Lecture]{
        let term = NSUserDefaults.standardUserDefaults().integerForKey(Config.userDefault.term)
        var res: [Lecture] = []
        for_i: for index in 0..<( LectureModel.HOL_NUM + 1 ) * ( LectureModel.VAR_NUM + 1 ) {
            let week = weekWithTapIndex(index)
            let time = periodWithTapIndex(index)
            if index == 0 || week == 0 || time == 0 { res.append(Lecture()); continue }
            let weekTime = weekTimeWithTapIndex(index)
            for lec in arr {
                for lecTerm in lec.term.componentsSeparatedByString(",") {
                    if String(term) == lecTerm {
                        if lec.myLecture == true {//&& lec.weekTime == weekTime {
                            for val in lec.weekTime.componentsSeparatedByString(",") {
                                if val == weekTime {
                                    res.append(lec)
                                    continue for_i
                                }
                            }
                        }
                    }
                }
            }
           res.append(Lecture())
        }
        return res
    }
    
    func weekTimeWithTapIndex(tapIndex: Int) -> String {
        let week = weekWithTapIndex(tapIndex)
        let period = periodWithTapIndex(tapIndex)
        return "\(week)\(period)"
    }
    
    func weekWithTapIndex(tapIndex: Int) -> Int {
        return tapIndex % ( LectureModel.HOL_NUM + 1 )
    }
    
    func periodWithTapIndex(tapIndex: Int) -> Int {
        return tapIndex / ( LectureModel.HOL_NUM + 1 )
    }
}

