//
//  Line.swift
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


class Line: Object {
    dynamic var id:         Int     = 0
    dynamic var accessId:   Int     = 0
    dynamic var name:       String  = ""
    let stations            = List<Station>()
    
    convenience init(json: SwiftyJSON.JSON) {
        self.init()
        self.id             = json["id"].intValue
        self.accessId       = json["access_id"].intValue
        self.name           = json["name"].stringValue
        for station in json["stations"].arrayValue {
            self.stations.append(Station(json: station))
        }
        
 
    }
    
    override static func primaryKey() -> String? { return "id" }
}
