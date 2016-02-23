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

class TimeTable: Object {
    dynamic var id: Int = 0
    dynamic var patternName: String = ""
    dynamic var time: String = ""
    dynamic var directionId: Int = 0
    convenience init(json: SwiftyJSON.JSON) {
        self.init()
        self.id = json["id"].intValue
        self.patternName = json["pattern_name"].stringValue
        self.time = json["time"].stringValue
    }
    
    override static func primaryKey() -> String? { return "id" }
}
