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
    dynamic var id:         Int     = 0
    var station: Station?
    var direction: Direction?
    var genre: Genre?
    let patterns = List<Pattern>()
    

    convenience init(json: SwiftyJSON.JSON) {
        self.init()
        self.id             = json["id"].intValue
        self.station        = Genre(json["station"])
        for pattern in json["patterns"].arrayValue {
            self.patterns.append(Pattern(json: pattern))
        }
    }
    
        override static func primaryKey() -> String? { return "id" }
}