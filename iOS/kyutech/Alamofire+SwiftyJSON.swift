//
//  Alamofire+SwiftyJSON.swift
//  kyutech
//
//  Created by shogo okamuro on 2/7/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON
import SHUtil

// MARK: - Request for Swift JSON
extension Request {
    
    /**
     Adds a handler to be called once the request has finished.
     
     :param: completionHandler A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the SwiftyJSON enum, if one could be created from the URL response and data, and any error produced while creating the SwiftyJSON enum.
     
     :returns: The request.
     */
    public func responseSwiftyJSON(completionHandler: (NSURLRequest, NSHTTPURLResponse?, SwiftyJSON.JSON, ErrorType?) -> Void) -> Self {
        return responseSwiftyJSON(nil, options:NSJSONReadingOptions.AllowFragments, completionHandler:completionHandler)
    }
    
    /**
     Adds a handler to be called once the request has finished.
     
     :param: queue The queue on which the completion handler is dispatched.
     :param: options The JSON serialization reading options. `.AllowFragments` by default.
     :param: completionHandler A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the SwiftyJSON enum, if one could be created from the URL response and data, and any error produced while creating the SwiftyJSON enum.
     
     :returns: The request.
     */
    public func responseSwiftyJSON(queue: dispatch_queue_t? = nil, options: NSJSONReadingOptions = .AllowFragments, completionHandler: (NSURLRequest, NSHTTPURLResponse?, SwiftyJSON.JSON, NSError?) -> Void) -> Self {
        return response(queue: queue) { (request, response, object, error) -> Void in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                {
//                    SHprint(object)
                    var responseJSON: SwiftyJSON.JSON
                    if error != nil || object == nil{
                        responseJSON = SwiftyJSON.JSON.null
                    } else {
                        responseJSON = SwiftyJSON.JSON(data: object!)
                    }
                    dispatch_async(queue ?? dispatch_get_main_queue(), {
                        completionHandler(request!, response, responseJSON, error)
                    })
            })
        }
    }
}
