//
//  Kyutech.swift
//  kyutech
//
//  Created by shogo okamuro on 2/7/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

struct CAMPUS {
    static let count = 3
    
    struct iizuka {
        static let name = "飯塚キャンパス"
        static let val = 1
    }
    
    struct tobata {
        static let name = "戸畑キャンパス"
        static let val = 0
    }
    
    struct wakamatsu {
        static let name = "若松キャンパス"
        static let val = 2
    }
    
    static func geyNameById(val: String) -> String? {
        switch val {
        case "1": return CAMPUS.iizuka.name
        case "0": return CAMPUS.tobata.name
        case "2": return CAMPUS.wakamatsu.name
        default: return nil
        }
    }
}

enum Menu: Int {
    case order = 0
    case category = 1
    case department = 2
    
}

class Sort: NSObject {
    dynamic var id : Int = 0
    dynamic var name = ""
    dynamic var imagePath = ""
            let menu : Menu
    dynamic var check = false
    
    init(id: Int, name: String, imagePath: String, menu: Menu) {
        self.id = id
        self.name = name
        self.imagePath = imagePath
        self.menu = menu
    }
}

