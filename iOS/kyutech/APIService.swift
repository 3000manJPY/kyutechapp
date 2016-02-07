//
//  APIService.swift
//  kyutech
//
//  Created by shogo okamuro on 2/6/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
//Alamofire
import Alamofire

enum RequestState :UInt {
    case None = 0
    case Requesting
    case Error
}

enum Router: URLRequestConvertible {
    static let baseURLString = "https://kyutechapp.planningdev.com/api/v2"
//    static var OAuthToken: String?
    
    case CreateUser([String: AnyObject])
    case GetAllNotice()
    case GetNotice(campusId: String)
    case GetAccess(String)
    case GetCalendar(String)

    
    var method: Alamofire.Method {
        switch self {
        case .CreateUser:
            return .POST
        case .GetAllNotice:
            return .GET
        case .GetNotice:
            return .GET
        case .GetAccess:
            return .GET
        case .GetCalendar:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .CreateUser:
            return "/users"
        case .GetAllNotice():
            return "/notices.json"
        case .GetNotice(let campusId):
            return "/notices/\(campusId)"
        case .GetAccess(let campusId):
            return "/notices/\(campusId)"
        case .GetCalendar(let campusId):
            return "/notices/\(campusId)"
        }
    }
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
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


