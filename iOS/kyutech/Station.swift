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
    dynamic var accessId: Int = 0
    
    convenience init(json: SwiftyJSON.JSON) {
        self.init()
        self.id             = json["id"].intValue
        self.name           = json["name"].stringValue
        self.accessId       = json["access_id"].intValue
    }
    
    override static func primaryKey() -> String? { return "id" }
}
