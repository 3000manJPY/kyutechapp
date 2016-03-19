//
//  Direction.swift
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

class Direction: Object {
    dynamic var id:             Int     = 0
    dynamic var stationId:      Int     = 0
    dynamic var name:  String  = ""
            let patterns                = List<Pattern>()
    
    convenience init(json: SwiftyJSON.JSON) {
        self.init()
        self.id             = json["id"].intValue
        self.stationId      = json["station_id"].intValue
        self.name           = json["name"].stringValue
        
        for pattern in json["patterns"].arrayValue {
            self.patterns.append(Pattern(json: pattern))
        }
        
    }
    
    override static func primaryKey() -> String? { return "id" }
}
