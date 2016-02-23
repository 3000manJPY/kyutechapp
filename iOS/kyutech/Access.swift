//
//  Access.swift
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


class Access: Object {
    dynamic var id:         Int    = 0
    dynamic var lineName:   String = ""
    dynamic var stationName:String = ""
            let directions         = List<Direction>()

    convenience init(json: SwiftyJSON.JSON) {
        self.init()
        self.id             = json["id"].intValue
        self.lineName       = json["line_name"].stringValue
        self.stationName    = json["station_name"].stringValue
        
        for direction in json["directions"].arrayValue {
            self.directions.append(Direction(json: direction))
        }
    }
    
        override static func primaryKey() -> String? { return "id" }
}