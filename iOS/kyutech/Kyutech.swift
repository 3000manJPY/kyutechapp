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
        static let rawValue = "1"
        static let name = "飯塚キャンパス"
        static let val  = 1
    }
    struct tobata {
        static let rawValue = "0"
        static let name = "戸畑キャンパス"
        static let val  = 0
    }
    struct wakamatsu {
        static let rawValue = "2"
        static let name = "若松キャンパス"
        static let val  = 2
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

class Term {
    subscript(index: Int) -> String {
        switch index {
        case 0: return "第1クォーター"
        case 1: return "第2クォーター"
        case 2: return "第3クォーター"
        case 3: return "第4クォーター"
        default: return ""
        }
    }
}