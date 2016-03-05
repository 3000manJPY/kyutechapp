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
        self.settingDate()
        self.setMylectureDataWithRealm()
        self.setSyllabusDataWithRealm()
    }
    
    func settingDate(){
        self.reqestLectures(CAMPUS.iizuka.val) { (lectures) -> () in
            if lectures.count <= 0 { return }
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
        var res: [Lecture] = []
        for_i: for index in 0..<( LectureModel.HOL_NUM + 1 ) * ( LectureModel.VAR_NUM + 1 ) {
            let week = index / ( LectureModel.HOL_NUM + 1 )
            let time = index % ( LectureModel.HOL_NUM + 1 )
            if index == 0 || week == 0 || time == 0 { res.append(Lecture()); continue }
            let weekTime = String( week * 10 + time )
            for lec in arr {
                if lec.myLecture == true {//&& lec.weekTime == weekTime {
                    for val in lec.weekTime.componentsSeparatedByString(",") {
                        if val == weekTime {
                            res.append(lec)
                            continue for_i
                        }
                    }
                }
            }
           res.append(Lecture())
        }
        return res
    }
}

