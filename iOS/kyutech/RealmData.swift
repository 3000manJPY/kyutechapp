//
//  RealmData.swift
//  kyutech
//
//  Created by shogo okamuro on 2/13/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import Foundation
import RealmSwift
import SHUtil
extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        
        return array
    }
}

class RealmData {
    class var sharedInstance: RealmData { struct Singleton { static let instance: RealmData = RealmData() }; return Singleton.instance }
    private init() {
        do {
            self.realm = try Realm()
        }
        catch let error {
            print(error)
            self.realm = nil
        }
    }
    
    let realm :Realm?
    
    
    //データの保存
    
    func save<T :Object>(data: T) -> Bool {
        do {
            let realm = try self.realm ?? Realm()
            try realm.write {
                realm.add(data, update: true)
            }
            return true
        }
        catch { return false }
    }
    
    func save<T :Object>(datas :[T]) -> Bool {
        do {
            let realm = try self.realm ?? Realm()
            try realm.write {
                realm.add(datas, update: true)
            }
            return true
        }
        catch {
            return false
        }
    }
    
    
    
    func getMyLectureData() -> [Lecture]? {
        do {
            let realm = try self.realm ?? Realm()
            return realm.objects(Lecture).toArray(Lecture)
        }
        catch { return nil }
    }

    func changeMylecture(lec: Lecture, flag: Bool) {
        do{
            let realm = try self.realm ?? Realm()
            try realm.write {
                lec.myLecture = flag
            }
            return
        }
        catch { return }
    }
    
    func changeMylectures(arr: [Lecture], flag: Bool) {
        do{
            let realm = try self.realm ?? Realm()
            try realm.write {
                for lec in arr {
                    lec.myLecture = flag
                }
            }
            return
        }
        catch { return }
    }
    
    
    func deleteAllWithCampusId(campus: Int) -> Bool {
        do {
            let campus = Config.getCampusId()
            let realm = try self.realm ?? Realm()
            let lecture = realm.objects(Lecture).filter{
                if campus != $0.campus_id { return false }
                return true
            }
            try realm.write {
                realm.delete(lecture)
            }
            
            return true
        }
        catch { return false }
        
    }
    
    
    //データの削除
    func deleteAllRecord<T :Object>(results :Results<T>) -> Bool {
        do {
            let realm = try self.realm ?? Realm()
            try realm.write {
                realm.delete(results)
            }
            
            return true
        }
        catch { return false }
    }
    
    // record
    func delete<T :Object>(object :T) -> Bool {
        do {
            let realm = try self.realm ?? Realm()
            try realm.write {
                realm.delete(object)
            }
            return true
        }
        catch { return false }
    }
    
}
