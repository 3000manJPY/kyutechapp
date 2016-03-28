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
    static let domain = "com.planningdev.kyutechapp"
    static let host         = Config.plist("baseURL")
    static let releaseNote = host + "/release_note/index"
    
    #if DEVELOP
    static let plistPath = "dev-api"
    #else
    static  let plistPath = "api"
    #endif
    
    static let maxConnections = 10
    
    struct notification {
        static let changeCampus = Config.domain + ".change.campus"
        
        static let applicationDidEnterBackground = Config.domain + "applicationDidEnterBackground"
        static let applicationWillEnterForeground = Config.domain + "applicationWillEnterForeground"
        
        struct notice   { static let open = Config.domain + "notice.open" }
        struct access   { static let open = Config.domain + "access.oepn" }
        struct lecture  { static let open = Config.domain + "lecture.open" }
    }
    struct userDefault {
        static let term = Config.domain + ".term"
        static let campus = Config.domain + ".campus"
        struct lecture {
            static let iizuka =    Config.domain + ".lecture.iizuka"
            static let wakamatsu =  Config.domain + ".lecture.wakamatsu"
            static let tobata =     Config.domain + ".lecture.tobata"
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
        
        
        struct access {
            struct iizuka {
                static let genre = "\(Config.domain).access.iizuka.genre"
                static let station = "\(Config.domain).access.iizuka.station"
                static let direction = "\(Config.domain).access.iizuka.direction"
            }
            struct tobata {
                static let genre = "\(Config.domain).access.tobata.genre"
                static let station = "\(Config.domain).access.tobata.station"
                static let direction = "\(Config.domain).access.tobata.direction"
            }
            struct wakamatsu {
                static let genre = "\(Config.domain).access.wakamatsu.genre"
                static let station = "\(Config.domain).access.wakamatsu.station"
                static let direction = "\(Config.domain).access.wakamatsu.direction"
            }
        }
        static func getAccessGenreKey() -> String {
            let campus = Config.getCampusId()
            switch campus {
            case CAMPUS.tobata.val:    return Config.userDefault.access.iizuka.genre
            case CAMPUS.wakamatsu.val: return Config.userDefault.access.wakamatsu.genre
            case CAMPUS.iizuka.val:    return Config.userDefault.access.iizuka.genre
            default: return ""
            }
            
        }
        
        static func getAccessStationKey() -> String {
            let campus = Config.getCampusId()
            switch campus {
            case CAMPUS.tobata.val:    return Config.userDefault.access.iizuka.station
            case CAMPUS.wakamatsu.val: return Config.userDefault.access.wakamatsu.station
            case CAMPUS.iizuka.val:    return Config.userDefault.access.iizuka.station
            default: return ""
            }
            
        }
        
        static func getAccessDirectionKey() -> String {
            let campus = Config.getCampusId()
            switch campus {
            case CAMPUS.tobata.val:    return Config.userDefault.access.iizuka.direction
            case CAMPUS.wakamatsu.val: return Config.userDefault.access.wakamatsu.direction
            case CAMPUS.iizuka.val:    return Config.userDefault.access.iizuka.direction
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
    
    static func getDarkThemeColor() -> UIColor {
        let campus = Config.getCampusId()
        switch campus {
        case CAMPUS.tobata.val: return CAMPUS.tobata.darkThemeColor
        case CAMPUS.iizuka.val: return CAMPUS.iizuka.darkThemeColor
        case CAMPUS.wakamatsu.val: return CAMPUS.wakamatsu.darkThemeColor
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



