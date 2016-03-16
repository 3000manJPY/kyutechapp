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
    var cacheLectures :[Lecture] = []
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

        if let v = RealmData.sharedInstance.getMyLectureData() {
           self.cacheLectures = v
            
            let campus = Config.getCampusId()
            self.reqestLectures(campus) { (lectures) -> () in
                if lectures.count <= 0 { return }
                self.cacheLectures = self.reflag(lectures, campus: campus)
                self.setsyllabusData(self.cacheLectures)
                self.setMylectureData(self.cacheLectures)
                
            }
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
        let arr = self.cacheLectures
        self.setsyllabusData(arr)
    }
    
    func updateSyllabusDataWithRealm(){
        let arr = self.cacheLectures
        LectureModel.sharedInstance.syllabusList = arr
    }
    
    private func setsyllabusData(arr: [Lecture]){
        self.syllabusList = arr
 
    }
    
    private func setMylectureDataWithRealm(){
        let arr = self.cacheLectures
        self.setMylectureData(arr)
    }
    
    private func setMylectureData(arr: [Lecture]){
        self.myLectures = self.mylectureAnal(arr)
 
    }
    
    func updateMylectureDataWithRealm(){
        let arr = self.cacheLectures
        LectureModel.sharedInstance.myLectures = self.mylectureAnal(arr)
    }
    
    private func mylectureAnal(arr: [Lecture]) -> [Lecture]{
        let term = NSUserDefaults.standardUserDefaults().integerForKey(Config.userDefault.term)
        let campus = Config.getCampusId()
        var lec: [String:Lecture] = [:]
        var res: [Lecture] = []
        for_i: for val in arr {
            if val.campus_id != campus || val.myLecture == false { continue for_i }
            term: for termStr in val.term.componentsSeparatedByString(",") {
                if String(term) != termStr { continue term }
                weekTime: for weekTimeStr in val.weekTime.componentsSeparatedByString(",") {
                    guard let weekTime = Int(weekTimeStr) else { continue weekTime }
                    let week = weekTime / 10
                    let time = weekTime % 10
                    let index = (LectureModel.HOL_NUM + 1) * time + week
                    lec["\(index)"] = val
                }
            }
        }
        for index in 0..<( LectureModel.HOL_NUM + 1 ) * ( LectureModel.VAR_NUM + 1 ) {
            guard let val = lec["\(index)"] else {
                res.append(Lecture())
                continue
            }
            res.append(val)
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
    
    func reflag(arr: [Lecture], campus: Int) -> [Lecture] {
        for new in arr {
            for lec in self.cacheLectures {
                if lec.campus_id != campus && lec.myLecture != false { continue }
                if new.id == lec.id {
                    new.myLecture = lec.myLecture
                }
            }
        }
        return arr
    }
    
    func getMylecture(term: String, weekTime: String) -> [Lecture] {
       let campus = Config.getCampusId()
        let lec = self.cacheLectures.filter{
            if campus != $0.campus_id { return false }
            for val in $0.weekTime.componentsSeparatedByString(",") {
                if val == weekTime {
                    for item in $0.term.componentsSeparatedByString(",") {
                        if item == term {
                            return true
                        }
                    }
                }
            }
            return false
        }
        return lec
    }
    func getMylecture(term: String ) -> [Lecture] {
        let campus = Config.getCampusId()
        let lec = self.cacheLectures.filter{
            if campus != $0.campus_id { return false }
            for item in $0.term.componentsSeparatedByString(",") {
                if item == term {
                    return true
                }
            }
            return false
        }
        return lec
    }
}

