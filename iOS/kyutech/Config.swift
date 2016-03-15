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
        static let changeCampus = "com.planningdev.kyutechapp.change.campus"
    }
    struct userDefault {
        static let term = "com.planningdev.kyutechapp.term"
        static let campus = "com.planningdev.kyutechapp.campus"
        struct lecture {
            static let iizuka =     "com.planningdev.kyutechapp.lecture.iizuka"
            static let wakamatsu =  "com.planningdev.kyutechapp.lecture.wakamatsu"
            static let tobata =     "com.planningdev.kyutechapp.lecture.tobata"
        }
        static func isUpdateLectureTime() -> String {
            let key = Config.userDefault.getLectureKey()
            if let val = NSUserDefaults.standardUserDefaults().objectForKey(key) {
                return String(val)
            }
            return ""
        }
        
        static func getLectureKey() -> String {
            let campus = Config.getCampusId()
            switch campus {
            case CAMPUS.tobata.val:    return Config.userDefault.lecture.tobata
            case CAMPUS.wakamatsu.val: return Config.userDefault.lecture.wakamatsu
            case CAMPUS.iizuka.val:    return Config.userDefault.lecture.iizuka
            default: return ""
            }
            
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


