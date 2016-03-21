//
//  Pattern.swift
//  kyutech
//
//  Created by shogo okamuro on 3/19/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//


import UIKit
import RealmSwift
import Foundation
import SwiftyJSON
import SHUtil


class Pattern: Object {
    dynamic var id:         Int    = 0
    dynamic var directionId:Int    = 0
    dynamic var name:       String = ""
    let timetables         = List<Timetable>()
    
    convenience init(json: SwiftyJSON.JSON) {
        self.init()
        self.id             = json["id"].intValue
        self.directionId    = json["direction_id"].intValue
        self.name           = json["name"].stringValue
        for timetable in json["timetables"].arrayValue {
            self.timetables.append(Timetable(json: timetable))
        }
    }
    
    override static func primaryKey() -> String? { return "id" }
}
