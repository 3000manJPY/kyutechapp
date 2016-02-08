//
//  Config.swift
//  kyutech
//
//  Created by shogo okamuro on 1/31/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

struct Config {
    static let maxConnections = 10
    
    struct notification {
        static let a = "12341234"
        static let key = "ABCD"
    }
    
    struct twitter {
        static let secret = "9887"
        static let key = "9723"
    }
}

struct Notif {
    struct notice { static let open = "NOTIFICATION_NOTICE_OPEN" }
    struct access { static let open = "NOTIFICATION_ACCESS_OPEN" }
    struct lecture { static let open = "NOTIFICATION_LECTURE_OPEN" }
}


