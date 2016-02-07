//
//  Kyutech.swift
//  kyutech
//
//  Created by shogo okamuro on 2/7/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

enum CAMPUS: Int {
    case iizuka = 1
    case tobata = 0
    case wakamatsu = 2
    
    func to_s() -> String {
        return String(self.rawValue)
    }
    
}

class Kyutech: NSObject {

}
