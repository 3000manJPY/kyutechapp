//
//  TimeTable.swift
//  kyutech
//
//  Created by shogo okamuro on 2/23/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation
import SwiftyJSON
import SHUtil

class Timetable: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var time: String = ""
            var originTime: NSData = NSData()
    dynamic var patternId: Int = 0
    convenience init(json: SwiftyJSON.JSON) {
        self.init()
        self.id         = json["id"].intValue
        self.patternId  = json["pattern_id"].intValue
        self.name       = json["name"].stringValue
        self.time       = "00:00"
    }
    
    override static func primaryKey() -> String? { return "id" }
}
