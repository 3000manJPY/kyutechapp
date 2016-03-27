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
    dynamic var id:   Int           = 0
    dynamic var name: String        = ""
    dynamic var hour: Int        = 0
    dynamic var minit:Int        = 0
    var originTime: NSData  = NSData()
    dynamic var patternId: Int      = 0
    
    convenience init(json: SwiftyJSON.JSON) {
        self.init()
        self.id         = json["id"].intValue
        self.patternId  = json["pattern_id"].intValue
        self.name       = json["name"].stringValue
        (self.hour,self.minit) = self.convertDateTimeFromString(json["time"].stringValue)
        
    }
    
    override static func primaryKey() -> String? { return "id" }
    
    func convertDateTimeFromString(str: String) -> (Int,Int) {
        let inputFormatter = NSDateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        guard let date: NSDate = inputFormatter.dateFromString(str) else { return (0,0) }
        
        let outputFormatter = NSDateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        let outputDateString = outputFormatter.stringFromDate(date)
        
        var hour = 0, minit = 0
        let val = outputDateString.componentsSeparatedByString(":")
        if let h = val.first {
            hour = Int(h) ?? 0
        }
        if let m = val.last {
            minit = Int(m) ?? 0
        }
        return (hour,minit)
    }
    
}
