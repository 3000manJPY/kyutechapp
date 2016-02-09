//
//  Config.swift
//  kyutech
//
//  Created by shogo okamuro on 1/31/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

struct Config {
    
    
    #if DEVELOP
    static let plistPath = "dev-api"
    #else
    static  let plistPath = "api"
    #endif
    
    static let maxConnections = 10
    
    struct notification {
        static let a = "12341234"
        static let key = "ABCD"
    }
    
    struct twitter {
        static let secret = "9887"
        static let key = "9723"
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
    struct notice { static let open = "NOTIFICATION_NOTICE_OPEN" }
    struct access { static let open = "NOTIFICATION_ACCESS_OPEN" }
    struct lecture { static let open = "NOTIFICATION_LECTURE_OPEN" }
}


