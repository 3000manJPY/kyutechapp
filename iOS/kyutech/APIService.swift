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
    case GetAllNotice()
    case GetNotice(campusId: String)
    case GetLecture(campusId: String)
    case GetAccess(campusId: String)
    case GetCalendar(campusId: String)
    var method: Alamofire.Method {
        switch self {
        case .CreateUser:   return .POST
        case .GetAllNotice: return .GET
        case .GetNotice:    return .GET
        case .GetLecture:   return .GET
        case .GetAccess:    return .GET
        case .GetCalendar:  return .GET
        }
    }
    var path: String {
        switch self {
        case .CreateUser:               return "/users"
        case .GetAllNotice():           return "/notices"
        case .GetNotice(let campusId):  return "/notices/\(campusId)"
//        case .GetLecture(let campusId): return "/lectures/\(campusId)"
        case .GetLecture(let campusId): return "/lectures/\(campusId)"
        case .GetAccess(let campusId):  return "/accesses"
//        case .GetAccess(let campusId):  return "/accesses/\(campusId)"
        case .GetCalendar(let campusId):return "/accesses/calendar/\(campusId)"
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
        Alamofire.request(Router.GetAllNotice()).responseSwiftyJSON({(request,response,jsonData,error) in
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
        Alamofire.request(Router.GetLecture(campusId: String(campus))).responseSwiftyJSON({(request,response,jsonData,error) in
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
        Alamofire.request(Router.GetAccess(campusId: String(campus))).responseSwiftyJSON({(request,response,jsonData,error) in
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

