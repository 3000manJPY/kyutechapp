//
//  Kyutech.swift
//  kyutech
//
//  Created by shogo okamuro on 2/7/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

protocol KyutechDelagate {
    func changeCampus(notification: NSNotification?)
    func setReceiveObserver()
}

struct CAMPUS {
    static let count = 3
    static let parentHP = "http://www.kyutech.ac.jp/"
    struct iizuka {
        static let rawValue = "1"
        static let name = "飯塚キャンパス"
        static let val  = 1
        static let hp = "http://www.iizuka.kyutech.ac.jp/"
        static let themeColor = UIColor.colorWith255(61, green: 184, blue: 235)
        static let darkThemeColor = UIColor.colorWith255(51, green: 174, blue: 225)
        static let topImage = UIImage(named: "top_image")
    }
    struct tobata {
        static let rawValue = "0"
        static let name = "戸畑キャンパス"
        static let val  = 0
        static let hp = "http://www.tobata.kyutech.ac.jp/"
        static let themeColor = UIColor.colorWith255(226, green: 94, blue: 157)
        static let darkThemeColor = UIColor.colorWith255(216, green: 84, blue: 147)
        static let topImage = UIImage(named: "tobata")
    }
    struct wakamatsu {
        static let rawValue = "2"
        static let name = "若松キャンパス"
        static let val  = 2
        static let hp = "http://www.lsse.kyutech.ac.jp/"
        static let themeColor = UIColor.colorWith255(170, green: 204, blue: 3)
        static let darkThemeColor = UIColor.colorWith255(167, green: 201, blue: 0)
        static let topImage = UIImage(named: "wakamatsu")
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

enum REQUIRED: Int {
    case sentakuHisshu = 1
    case hisshu = 0
    case sentaku = 2
    case etc = 3
    
    func name() -> String {
        switch self{
        case .sentakuHisshu: return "選択・必修"
        case .hisshu: return "必修"
        case .sentaku: return "選択"
        case .etc: return "不明"
        }
    }
    
    static func getRequiredWithNum(num: Int) -> REQUIRED {
        switch num {
        case REQUIRED.sentakuHisshu.rawValue: return .sentakuHisshu
        case REQUIRED.hisshu.rawValue: return .hisshu
        case REQUIRED.sentaku.rawValue: return .sentaku
        case REQUIRED.etc.rawValue: return .etc
        default: return .etc
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
        case 1: return "第1クォーター"
        case 2: return "第2クォーター"
        case 3: return "第3クォーター"
        case 4: return "第4クォーター"
        default: return ""
        }
    }
}

