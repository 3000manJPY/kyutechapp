//
//  Notice.swift
//  kyutech
//
//  Created by shogo okamuro on 2/6/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//


import UIKit
import RealmSwift
import Realm

//import Alamofire
import Foundation
import SwiftyJSON

class Notice: RLMObject {
    
    private dynamic var id: Int64 = 0
    private dynamic var uid: Int64 = 0
    
    dynamic var title: String = ""
    private dynamic var details: String = ""
    dynamic var categoryId: String = ""
    dynamic var departmentId: String = ""
    private dynamic var campusId: String = ""
    private dynamic var date: Int64 = 0
    private dynamic var periodTime: String = ""
    private dynamic var grade: String = ""
    private dynamic var place: String = ""
    private dynamic var subject: String = ""
    private dynamic var teacher: String = ""
    private dynamic var beforeData: String = ""
    private dynamic var afterData: String = ""
    private dynamic var webUrl: String = ""
    private dynamic var note: String = ""
    
    
    private dynamic var doc1Name: String = ""
    private dynamic var doc2Name: String = ""
    private dynamic var doc3Name: String = ""
    private dynamic var doc4Name: String = ""
    private dynamic var doc5Name: String = ""
    private dynamic var doc1Url: String = ""
    private dynamic var doc2Url: String = ""
    private dynamic var doc3Url: String = ""
    private dynamic var doc4Url: String = ""
    private dynamic var doc5Url: String = ""
    private dynamic var registtime: Int64 = 0
    
    
    convenience init(json: JSON) {
        self.init()//        super.init()
        //        print(json)
        self.id = json["id"].int64Value
        self.uid = json["id"].int64Value
        
        self.title = json["title"].stringValue
        self.details = json["details"].stringValue
        self.categoryId = json["category_id"].stringValue
        self.departmentId = (json["department_id"].stringValue == "99") ? "0" : json["department_id"].stringValue
        self.campusId = json["campus_id"].stringValue
        self.date = json["date"].int64Value
        self.periodTime = json["period_time"].stringValue
        
        self.grade = json["grade"].stringValue
        self.place = json["place"].stringValue
        self.subject = json["subject"].stringValue
        self.teacher = json["teacher"].stringValue
        self.beforeData = json["before_data"].stringValue
        self.afterData = json["after_data"].stringValue
        self.webUrl = json["web_url"].stringValue
        self.note = json["note"].stringValue
        
        self.doc1Name = json["document1_name"].stringValue
        self.doc2Name = json["document2_name"].stringValue
        self.doc3Name = json["document3_name"].stringValue
        self.doc4Name = json["document4_name"].stringValue
        self.doc5Name = json["document5_name"].stringValue
        
        self.doc1Url = json["document1_url"].stringValue
        self.doc2Url = json["document2_url"].stringValue
        self.doc3Url = json["document3_url"].stringValue
        self.doc4Url = json["document4_url"].stringValue
        self.doc5Url = json["document5_url"].stringValue
        
        self.registtime = json["regist_time"].int64Value
//        super.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
//    override class func ignoredProperties() -> [AnyObject]! {
//        return ["bar"]
//    }
////    override init() {
//        super.init()
//    }

   

//    required init() {
//    }

    
    
//    func propatyList() -> [[String:String]] {
//        var array :[[String:String]] = [[:]]
//        
//        if self.title       != "" { array.append(["お知らせ":self.title])}
//        if self.details != "" { array.append(["詳細": self.details ])}
//        array.append(["カテゴリー": Config_Category.getCategoryNameWithId(self.category_id) ])
//        array.append(["学部・大学院": Config_Category.getDepartmentNameWithId(self.department_id) ])
//        array.append(["キャンパス": CAMPUS.name(Int(self.campus_id) ?? 99 ) ])
//        if self.date > 0 { array.append(["日付": UNIXTime.to_i(self.date) ])}
//        if self.period_time != "" { array.append(["時間": self.period_time ])}
//        if self.grade != "" { array.append(["対象学年": self.grade ])}
//        if self.place != "" { array.append(["場所": self.place ])}
//        if self.subject != "" { array.append(["科目": self.subject ])}
//        if self.teacher != "" { array.append(["担当教員": self.teacher ])}
//        if self.before_data != "" { array.append(["変更前": self.before_data ])}
//        if self.after_data != "" { array.append(["変更後": self.after_data ])}
//        if self.web_url != "" { array.append(["リンク": self.web_url ])}
//        if self.note != "" { array.append(["その他": self.note ])}
//        
//        if self.doc1_url != "" { array.append([self.doc1_nane != "" ? self.doc1_nane : "資料1": self.doc1_url])}
//        if self.doc2_url != "" { array.append([self.doc2_nane != "" ? self.doc2_nane : "資料2": self.doc2_url])}
//        if self.doc3_url != "" { array.append([self.doc3_nane != "" ? self.doc3_nane : "資料3": self.doc3_url])}
//        if self.doc4_url != "" { array.append([self.doc4_nane != "" ? self.doc4_nane : "資料4": self.doc4_url])}
//        if self.doc5_url != "" { array.append([self.doc5_nane != "" ? self.doc5_nane : "資料5": self.doc5_url])}
//        
//        return array
//    }
}
