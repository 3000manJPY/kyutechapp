//
//  AccessModel.swift
//  kyutech
//
//  Created by shogo okamuro on 2/23/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
import Alamofire
import SHUtil


class AccessModel: NSObject {
    class var sharedInstance: AccessModel { struct Singleton { static let instance: AccessModel = AccessModel() }; return Singleton.instance }

    dynamic var accesses: [Access] = []
    
    private var requestState :RequestState = .None {
        willSet {
            switch  newValue {
            case .None, .Error :
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            case .Requesting :
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            }
        }
    }
    
    private override init() {
        super.init()
        self.updateDate()
    }
    
    func updateDate(){
        let campus = Config.getCampusId()
        self.reqestAccesses(campus) { (accesses) -> () in
            AccessModel.sharedInstance.accesses = accesses
        }
    }
    
    private func reqestAccesses(campus: Int, completion: ([Access]) -> ()){
        if self.requestState == .Requesting { return }
        APIService.reqestAccesses(campus, completionHandler: { (accesses) -> () in
            self.requestState = .None
            completion(accesses)
            }) { (type, code) -> () in
                self.requestState = .Error
        }
    }
}
