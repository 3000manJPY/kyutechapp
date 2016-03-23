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
import RealmSwift

struct HourMinits {
    var h: Int
    var m: [Int]
}

class AccessModel: NSObject {
    class var sharedInstance: AccessModel { struct Singleton { static let instance: AccessModel = AccessModel() }; return Singleton.instance }

    var accesses    :[Access] = []
    dynamic var genres      :[Genre] = []
    dynamic var stations    :[Station] = []
    dynamic var directions  :[Direction] = []
    
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
        self.updateData()
    }
    
    func updateData(){
        let campus = Config.getCampusId()
        self.reqestAccesses(campus) { (accesses) -> () in
            self.accesses = accesses
            self.dataAnal(genreId: nil, stationId: nil, directionId: nil)
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
    
    func dataAnal(genreId genreId:Int?, stationId:Int?, directionId:Int?){
        var dicGenre: [Int:Genre] = [:] ,genres:[Genre] = []
        var dicStation: [Int:Station] = [:], stations:[Station] = []
        var dicDirection: [Int:Direction] = [:], directions:[Direction] = []
        for access in self.accesses {
            guard let genre = access.genre else{ continue }
            if genreId == nil || genreId == genre.id {
                dicGenre[genre.id] = genre
            }else{
                continue
            }
            guard let station = access.station else{ continue }
            if stationId == nil || stationId == station.id {
                dicStation[station.id] = station
            }else{
                continue
            }
            guard let direction = access.direction else{ continue }
            if directionId == nil || directionId == direction.id {
                dicDirection[direction.id] = direction
            }else{
                continue
            }
        }
        for val in dicGenre     { genres.append(val.1) }
        for val in dicStation   { stations.append(val.1) }
        for val in dicDirection { directions.append(val.1) }
        
        AccessModel.sharedInstance.genres = genres
        AccessModel.sharedInstance.stations = stations
        AccessModel.sharedInstance.directions = directions
        
    }
    
    //６時始まりの配列を返す
    func get6StartTimetables(timetables: List<Timetable>) -> [HourMinits] {
        var res: [HourMinits] = []
        let sorted = timetables.sort { (lhs, rhs) in return lhs.hour == rhs.hour ? lhs.minit < rhs.minit : lhs.hour < rhs.hour }
        for num in 0..<24 {
            var hour = num + 6
            if hour > 24 { hour -= 24 }
            var obj = HourMinits.init(h: hour, m: [])
            for val in sorted {
                if val.hour == obj.h { obj.m.append(val.minit) }
            }
            res.append(obj)
        }
        return res
    }
}
