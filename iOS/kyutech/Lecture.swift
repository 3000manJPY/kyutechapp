//
//  Lecture.swift
//  kyutech
//
//  Created by shogo okamuro on 2/11/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation
import SwiftyJSON
import SHUtil



class Lecture: Object {
            dynamic var id = ""
            dynamic var title = ""
            dynamic var campus_id = 0
    private dynamic var date = 0
            dynamic var teacher = ""
            dynamic var term = ""
    private dynamic var registtime = 0
    private dynamic var uid = 0
            dynamic var weekTime = ""
            dynamic var room = ""
            dynamic var myLecture = false
    private dynamic var preparation = ""
    private dynamic var book = ""
    private dynamic var evaluation = ""
    private dynamic var plan = ""
    private dynamic var keyword = ""
    private dynamic var overview = ""
    private dynamic var purpose = ""
    private dynamic var credit = 0
    private dynamic var required = 0
            dynamic var class_num = ""
    private dynamic var title_en = ""
    private dynamic var updatetime = 0
    private dynamic var year = ""
    
    convenience init(json: SwiftyJSON.JSON) {
        self.init()//        super.init()
        self.id = json["id"].stringValue
        self.updateWithJSON(json)
    }
    func updateWithJSON(json:SwiftyJSON.JSON){
        self.campus_id  = json["campus_id"].intValue
        self.title      = json["title"].stringValue
        self.date       = json["date"].intValue
        self.registtime = json["created_at"].intValue
        self.term       = json["term"].stringValue
        self.teacher    = json["teacher"].stringValue
        self.weekTime  = json["week_time"].stringValue
        self.uid        = json["uid"].intValue
        self.room       = json["room"].stringValue
        self.preparation = json["pre[aration"].stringValue
        self.book       = json["book"].stringValue
        self.evaluation = json["evaluation"].stringValue
        self.plan       = json["plan"].stringValue
        self.keyword    = json["keyword"].stringValue
        self.overview   = json["overview"].stringValue
        self.purpose    = json["purpose"].stringValue
        self.credit     = json["credit"].intValue
        self.required   = json["required"].intValue
        self.class_num  = json["class_num"].stringValue
        self.title_en   = json["title_en"].stringValue
        self.updatetime = json["updated_at"].intValue
        self.year       = json["year"].stringValue
    }
    
    // primaryKeyの指定.
    override class func primaryKey() -> String { return "id" }
   
    func propatyList() -> [[String:String]] {
        var array :[[String:String]] = [[:]]
        if self.title       != "" { array.append(["科目名":self.title])}
        if self.teacher     != "" { array.append(["担当教諭":self.teacher])}
        if self.year        != "" { array.append(["学年":self.year])}
        if self.class_num   != "" { array.append(["クラス":self.class_num])}
        if self.room        != "" { array.append(["教室":self.room])}
        if self.term        != "" { array.append(["ターム":self.term])}
        if self.weekTime    != "" {
            var str = ""
            for val in self.weekTime.componentsSeparatedByString(",") {
                if let weekTimeNum = Int(val) {
                    let weekNum = weekTimeNum / 10
                    let periodNum = weekTimeNum % 10
                    str += WEEKS.getWeekWithNum(weekNum).name() + "\(periodNum)　"
                }
            }
            array.append(["曜日・時限":str])
        }
        array.append(["単位区分":REQUIRED.getRequiredWithNum(self.required).name()])
        if self.credit      > 0   { array.append(["単位数":self.credit.description])}
        if self.overview    != "" { array.append(["概要":self.overview])}
        if self.purpose     != "" { array.append(["目的":self.purpose])}
        if self.plan        != "" { array.append(["授業計画":self.plan])}
        if self.preparation != "" { array.append(["予習・復習":self.preparation])}
        if self.book        != "" { array.append(["参考書・教科書":self.book])}
        if self.evaluation  != "" { array.append(["評価":self.evaluation])}
        if self.keyword     != "" { array.append(["キーワード":self.keyword])}


        if self.title_en    != "" { array.append(["科目名(英語)":self.title_en])}
        return array
    }
}







