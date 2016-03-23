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
    dynamic var accessId:      Int     = 0
    dynamic var name:  String  = ""
    
    convenience init(json: SwiftyJSON.JSON) {
        self.init()
        self.id             = json["id"].intValue
        self.accessId      = json["access_id"].intValue
        self.name           = json["name"].stringValue
        
    }
    
    override static func primaryKey() -> String? { return "id" }
}
