//
//  NoticeModel.swift
//  kyutech
//
//  Created by shogo okamuro on 2/6/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
import Alamofire
import SHUtil


class NoticeModel: NSObject {
    class var sharedInstance: NoticeModel { struct Singleton { static let instance: NoticeModel = NoticeModel() }; return Singleton.instance }
    dynamic var notices     : [Notice] = []
    var sort: Sort?
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
        self.reqestNotices(CAMPUS.iizuka.val) { (notices) -> () in
//            self.tmpArray = notices
            self.sortData(notices, sort: self.sort)
        }
    }

    func sortData(notices: [Notice]?, sort: Sort?){
        let arr = notices ?? self.notices
        let num = sort?.id ?? 0
        switch num {
        case 0: //新着順
            self.notices = arr.sort{ $0.registtime > $1.registtime }
            break
        case 1: //日付が近い順
            let now = Int64(NSDate().timeIntervalSince1970)
            self.notices = arr.sort{ return abs( $0.date - now ) < abs( $1.date - now ) }
            break
        case 2: //日付順
            self.notices = arr.sort{ $0.date > $1.date}
            break
        default: break
            
        }
    }
    
    private func reqestNotices(campus: Int, completion: ([Notice]) -> ()){
        if self.requestState == .Requesting { return }
        Alamofire.request(Router.GetAllNotice()).responseSwiftyJSON({(request,response,jsonData,error) in
            guard let res = response else {
                SHprint("error! no response")
                self.requestState = .Error
                return
            }
            if res.statusCode < 200 && res.statusCode >= 300 {
                SHprint("error!! status => \(res.statusCode)")
                self.requestState = .Error
                return
            }
            
            var arr: [Notice] = []
            for (_,json) in jsonData {
                arr.append(Notice(json: json))
            }
            
            self.requestState = .None
            completion(arr)
        })
    }
}
