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
    
//    case iizuka = 1
//    case tobata = 0
//    case wakamatsu = 2
//    
//    func name() -> String {
//        return String(self.rawValue)
//    }
//   
    static func geyNameById(val: String) -> String? {
        switch val {
        case "1": return CAMPUS.iizuka.name
        case "0": return CAMPUS.tobata.name
        case "2": return CAMPUS.wakamatsu.name
        default: return nil
        }
    }
}

class Category: NSObject {
    dynamic var id : Int = 0
    dynamic var name = ""
    dynamic var imagePath = ""
    
    init(id: Int, name: String, imagePath: String) {
        self.id = id
        self.name = name
        self.imagePath = imagePath
    }
   
}

class Department: NSObject {
    dynamic var id : Int = 0
    dynamic var name = ""
    dynamic var imagePath = ""
    
    init(id: Int, name: String, imagePath: String) {
        self.id = id
        self.name = name
        self.imagePath = imagePath
    }
    
    
}

class Kyutech: NSObject {

}
