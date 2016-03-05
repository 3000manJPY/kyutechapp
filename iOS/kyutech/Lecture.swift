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
    private dynamic var campus_id = 0
    private dynamic var date = 0
            dynamic var teacher = ""
    private dynamic var term = ""
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
    private dynamic var class_num = ""
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
    
}