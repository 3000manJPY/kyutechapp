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
    class var sharedInstance: LectureModel { struct Singleton { static let instance: LectureModel = LectureModel() }; return Singleton.instance }
    static let HOL_NUM = 5
    static let VAR_NUM = 6
    dynamic var myLectures   : [Lecture] = []
    dynamic var syllabusList : [Lecture] = []
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
        self.updateDate()
        self.setFirstNilData()
    }
    
    func updateDate(){
        self.reqestLectures(CAMPUS.iizuka.val) { (lectures) -> () in
            self.syllabusList = lectures
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
    
    private func setMylectureData(){
        var arr: [Lecture] = []
        for index in 0..<(LectureModel.HOL_NUM + 1 ) * (LectureModel.VAR_NUM + 1) {
            
        }
        self.myLectures = arr
    }
    
    private func setFirstNilData(){
        var arr: [Lecture] = []
        for _ in 0..<(LectureModel.HOL_NUM + 1 ) * (LectureModel.VAR_NUM + 1) {
            arr.append(Lecture())
        }
       self.myLectures = arr
    }
//        guard let data = RealmData.sharedInstance.getMyLectureData() else{ return }
//        for _ in 0..<LectueModel.HOL_NUM * LectueModel.VAR_NUM {
//            for lec in data {
//                if lec.week_time ==
//            }
//        }
}