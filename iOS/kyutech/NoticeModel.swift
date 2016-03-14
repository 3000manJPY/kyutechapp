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
    var tmpArray : [Notice] = []
    var original : [Notice] = []
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
        self.reqestNotices(campus) { (notices) -> () in
            self.notices  = notices
            self.original = notices
//            MenuModel.sharedInstance.setMenuArray(MenuModel.sharedInstance.menus)
        }
    }

    func sortData(sort: Sort?){
        let arr = self.tmpArray
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
    
    func filterCategory(sort: [Sort]){
        for cate in sort {
            if cate.check == true {
                if cate.id == 100 {
                    self.tmpArray = self.original; return }
                self.tmpArray += self.original.filter{ $0.categoryId == String(cate.id)}
            }
        }
    }
    
    func filterDetartment(sort: [Sort]){
        var arr: [Notice] = []
        for depa in sort {
            if depa.check == true {
                if depa.id == 0 { return }
                arr += self.tmpArray.filter{ $0.departmentId == String(depa.id) }
            }
        }
        self.tmpArray = arr
    }
    
    private func reqestNotices(campus: Int, completion: ([Notice]) -> ()){
        if self.requestState == .Requesting { return }
        APIService.reqestNotices(campus, completionHandler: { (notices) -> () in
            self.requestState = .None
            completion(notices)
            }) { (type, code) -> () in
                self.requestState = .Error
        }
    }
}
