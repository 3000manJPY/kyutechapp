//
//  Station.swift
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


class Station: Object {
    dynamic var id:         Int    = 0
    dynamic var name:       String = ""
    let directions         = List<Direction>()
    let lines              = List<Line>()
    
    convenience init(json: SwiftyJSON.JSON) {
        self.init()
        self.id             = json["id"].intValue
        self.name           = json["name"].stringValue
        for direction in json["directions"].arrayValue {
            self.directions.append(Direction(json: direction))
        }
        for line in json["lines"].arrayValue {
            self.lines.append(Line(json: line))
        }
    }
    
    override static func primaryKey() -> String? { return "id" }
}
