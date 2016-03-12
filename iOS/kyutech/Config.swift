//
//  Config.swift
//  kyutech
//
//  Created by shogo okamuro on 1/31/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

struct Config {
    static let padHP = "https://www.planningdev.com"
    static let about = ""
    static let notice = ""
    
    
    #if DEVELOP
    static let plistPath = "dev-api"
    #else
    static  let plistPath = "api"
    #endif
    
    static let maxConnections = 10
    
    struct notification {
        
    }
    struct userDefault {
        static let term = "com.planningdev.kyutechapp.term"
        static let campus = "com.planningdev.kyutechapp.campus"
        static let updateLecture = "com.planningdev.kyutechapp.lecture.update"
        static func isUpdateLectureTime() -> String {
            if let val = NSUserDefaults.standardUserDefaults().objectForKey(Config.userDefault.updateLecture) {
                return String(val)
            }
            return ""
        }
    
    }
    
    static func getCampusId() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(Config.userDefault.campus)
    }
    
    static func getThemeColor() -> UIColor {
        let campus = Config.getCampusId()
        switch campus {
        case CAMPUS.tobata.val: return CAMPUS.tobata.themeColor
        case CAMPUS.iizuka.val: return CAMPUS.iizuka.themeColor
        case CAMPUS.wakamatsu.val: return CAMPUS.wakamatsu.themeColor
        default: return UIColor.blackColor()
        }
    }
    
    static func plist(property:String)->String{
        let path = NSBundle.mainBundle().pathForResource(Config.plistPath, ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        if let string = dict?.valueForKey(property) as? String{
            return string
        }
        return ""
    }
}

struct Notif {
    struct notice   { static let open = "NOTIFICATION_NOTICE_OPEN" }
    struct access   { static let open = "NOTIFICATION_ACCESS_OPEN" }
    struct lecture  { static let open = "NOTIFICATION_LECTURE_OPEN" }
}


