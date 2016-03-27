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
    var firstGenre  :[Genre] = []
    dynamic var stations    :[Station] = []
    dynamic var directions  :[Direction] = []
    dynamic var patterns    :[Pattern] = []
    
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
            self.initDataAnal()
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
    
    func  initDataAnal() {
        self.updateDataAnal(genreId: nil, stationId: nil, directionId: nil)
        AccessModel.sharedInstance.genres = self.firstGenre
        //        AccessModel.sharedInstance.updateDataAnal(genreId: self.firstGenre.first?.id, stationId: nil, directionId: nil)
    }
    
    func  getPickerData() {
        
    }
    
    func updateDataAnal(genreId genreId:Int?, stationId:Int?, directionId:Int?){
        var dicGenre: [Int:Genre] = [:]
        var dicStation: [Int:Station] = [:]//, stations:[Station] = []
        var dicDirection: [Int:Direction] = [:]//, directions:[Direction] = []
        var dicPattern: [Int:List<Pattern>] = [:]//, patterns:[Pattern] = []
        
        for access in self.accesses {
            guard let genre = access.genre ,let station = access.station ,let direction = access.direction else{ continue }
            
            station.enablet = false
            direction.enablet = false
            
            if genreId != nil && genreId != genre.id { continue }
            
            if stationId != nil && stationId != station.id {
                station.enablet = true
                direction.enablet = true
            }
            if directionId != nil && directionId != direction.id {
                direction.enablet = true
                station.enablet = true
            }
            
            if stationId == nil && directionId != nil {
                direction.enablet = false
            }
            
            dicGenre[genre.id] = genre
            
            if dicStation[station.id]?.enablet == true {
            }else{
                dicStation[station.id] = station
            }
            if dicDirection[direction.id]?.enablet == false {
            }else{
                dicDirection[direction.id] = direction
            }
            
            if directionId != nil && stationId != nil && station.enablet == false && direction.enablet == false {
                dicPattern[access.id] = access.patterns
            }
        }
        let stations = self.flatStationDictionary(dicStation)
        let directions = self.flatDirectionDictionary(dicDirection)
        let genres = self.flatGenreDictionary(dicGenre)
        let patterns = self.flatPatternDictionary(dicPattern)
        
        //        if genreId != nil && stationId == nil && directionId == nil {
        //            self.firstSettings(genreId,genres: genres, stations: stations, directions: directions)
        //        }else{
        
        self.updateAccesses(genres, stations: stations, directions: directions, patterns: patterns)
        //
        //        }
        
    }
    
    func flatGenreDictionary(dicGenre:[Int:Genre]) -> [Genre] {
        var genres:[Genre] = []
        for val in dicGenre     { genres.append(val.1) }
        return genres
    }
    
    func flatStationDictionary(dicStation:[Int:Station]) -> [Station] {
        var stations:[Station] = []
        for val in dicStation     { stations.append(val.1) }
        return stations
    }
    
    func flatDirectionDictionary(dicDirection:[Int:Direction]) -> [Direction] {
        var direction:[Direction] = []
        for val in dicDirection     { direction.append(val.1) }
        return direction
    }
    
    func flatPatternDictionary(dicPattern:[Int:List<Pattern>]) -> [Pattern] {
        var patterns:[Pattern] = []
        for (index,val) in dicPattern.enumerate() {
            
            if index > 1 {
                SHprint(dicPattern)
                //error!!!!!!!!!!!!
            }
            
            for pa in val.1 {
                patterns.append(pa)
            }
        }
        return patterns
    }
    
    
    
    func firstSettings(genreId: Int?,genres: [Genre], stations: [Station], directions: [Direction]) {
        guard let stationFirst = stations.first ,let directionFirst = directions.first else { return }
        var dicPattern:[Int:List<Pattern>] = [:]
        for access in self.accesses {
            guard let genre = access.genre ,let station = access.station ,let direction = access.direction else{ continue }
            if genreId != nil && genreId != genre.id { continue }
            if stationFirst.id == station.id && directionFirst.id == direction.id {
                dicPattern[access.id] = access.patterns
            }
        }
        
        
        self.updateAccesses(genres, stations: [stationFirst], directions: [directionFirst], patterns: self.flatPatternDictionary(dicPattern))
        
    }
    
    func  updateAccesses(genres: [Genre], stations: [Station], directions: [Direction], patterns: [Pattern]){
        
        
        self.firstGenre = genres.sort({ (lv, rv) -> Bool in
            return lv.id < rv.id
        })
        
        AccessModel.sharedInstance.stations = stations.sort({ (lv, rv) -> Bool in
            return lv.id < rv.id
        })
        AccessModel.sharedInstance.directions = directions.sort({ (lv, rv) -> Bool in
            return lv.id < rv.id
        })
        
        if patterns.count > 0 {
            AccessModel.sharedInstance.patterns = patterns.sort({ (lv, rv) -> Bool in
                return lv.id < rv.id
            })
        }
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
