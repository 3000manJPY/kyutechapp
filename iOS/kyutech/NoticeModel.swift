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
    class var sharedInstance: NoticeModel {
        struct Singleton {
            static let instance: NoticeModel = NoticeModel()
        }
        return Singleton.instance
    }

    
    dynamic var notices: [Notice] = []
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
//        self.hoge = "asdf"
    }
    
    func updateDate(){
        self.reqestNotices(CAMPUS.iizuka) { (notices) -> () in
            self.notices = []
        }
    }

    private func reqestNotices(campus: CAMPUS, completion: ([Notice]) -> ()){
        if self.requestState == .Requesting { return }

//        Alamofire.request(Router.GetNotice(campusId: campus.to_s())).responseSwiftyJSON({(request,response,jsonData,error) in
        Alamofire.request(Router.GetAllNotice()).responseSwiftyJSON({(request,response,jsonData,error) in
//            SHprint(request)
//            SHprint(jsonData)
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
