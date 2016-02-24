//
//  APIService.swift
//  kyutech
//
//  Created by shogo okamuro on 2/6/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
import Alamofire
import SHUtil
import SwiftyJSON

enum RequestState :UInt {
    case None = 0
    case Requesting
    case Error
}

enum Router: URLRequestConvertible {
    static let host         = Config.plist("baseURL")
    static let version      = Config.plist("apiVersion")
    static let apiBaseURL   = "\(Router.host)/api/\(Router.version)"
    case CreateUser([String: AnyObject])
    case GetAllNotices()
    case GetNoticeWithCampusId(campusId: String)
    case GetNoticeWithNoticeId(noticeId: String)
    case GetAllLectures()
    case GetLectureWithCampusId(campusId: String)
    case GetLectureWithLectureId(lectureId: String)
    case GetAllAccesses()
    case GetAccessWithCampusId(campusId: String)
    case GetAccessWithAccessId(accessId: String)
    case GetCalendar(campusId: String)
    var method: Alamofire.Method {
        switch self {
        case .CreateUser:               return .POST
        case .GetAllNotices:            return .GET
        case .GetNoticeWithCampusId:    return .GET
        case .GetNoticeWithNoticeId:    return .GET
        case GetAllLectures:            return .GET
        case GetLectureWithCampusId:    return .GET
        case GetLectureWithLectureId:   return .GET
        case GetAllAccesses:            return .GET
        case GetAccessWithCampusId:     return .GET
        case GetAccessWithAccessId:     return .GET
        case GetCalendar:               return .GET
        }
    }
    var path: String {
        switch self {
        case CreateUser:                                return "/users"
        case GetAllNotices():                           return "/notices"
        case GetNoticeWithCampusId(let campusId):       return "/notices?campus_id=\(campusId)"
        case GetNoticeWithNoticeId(let noticeId):       return "/notice/\(noticeId)"
        case GetAllLectures():                          return "/lectures"
        case GetLectureWithCampusId(let campusId):      return "/lectures?campus_id=\(campusId)"
        case GetLectureWithLectureId(let lectureId):    return "/lecture/\(lectureId)"
        case GetAllAccesses():                          return "/accesses"
        case GetAccessWithCampusId(let campusId):       return "/accesses?campus_id=\(campusId)"
        case GetAccessWithAccessId(let accessId):       return "/access/\(accessId)"
        case GetCalendar:                               return "/calender/"
        }
    }
    // MARK: URLRequestConvertible
    var URLRequest: NSMutableURLRequest {
        let URL               = NSURL(string: Router.apiBaseURL)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
//        if let token = Router.OAuthToken {
//            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
        
        switch self {
        case .CreateUser(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
//        case .UpdateUser(_, let parameters):
//            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
    
}


struct APIService {
    static func reqestNotices(campus: Int,completionHandler: ([Notice]) -> (), errorHandler: (ErrorType?,Int) -> ()) -> () {
        Alamofire.request(Router.GetNoticeWithCampusId(campusId: String(campus))).responseSwiftyJSON({(request,response,jsonData,error) in
            guard let res = response else {
                SHprint("error! no response")
                return
            }
            if res.statusCode < 200 && res.statusCode >= 300 {
                SHprint("error!! status => \(res.statusCode)")
                return
            }
            var arr: [Notice] = []
            for (_,json) in jsonData {
                arr.append(Notice(json: json))
            }
            completionHandler(arr)
        })
    }
    static func reqestLectures(campus: Int,completionHandler: ([Lecture]) -> (), errorHandler: (ErrorType?,Int) -> ()) -> () {
        Alamofire.request(Router.GetLectureWithCampusId(campusId: String(campus))).responseSwiftyJSON({(request,response,jsonData,error) in
            guard let res = response else {
                SHprint("error! no response")
                return
            }
            if res.statusCode < 200 && res.statusCode >= 300 {
                SHprint("error!! status => \(res.statusCode)")
                return
            }
            var arr: [Lecture] = []
            for (_,json) in jsonData {
                arr.append(Lecture(json: json))
            }
            completionHandler(arr)
        })
    }
    
    static func reqestAccesses(campus: Int,completionHandler: ([Access]) -> (), errorHandler: (ErrorType?,Int) -> ()) -> () {
        Alamofire.request(Router.GetAccessWithCampusId(campusId: String(campus))).responseSwiftyJSON({(request,response,jsonData,error) in
            guard let res = response else {
                SHprint("error! no response")
                return
            }
            if res.statusCode < 200 && res.statusCode >= 300 {
                SHprint("error!! status => \(res.statusCode)")
                return
            }
            var arr: [Access] = []
            for (_,json) in jsonData {
                arr.append(Access(json: json))
            }
            completionHandler(arr)
        })
    }
    
}

