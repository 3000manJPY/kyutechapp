//
//  CategoryModel.swift
//  kyutech
//
//  Created by shogo okamuro on 2/8/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
import SHUtil


class MenuModel: NSObject {
    class var sharedInstance: MenuModel { struct Singleton { static let instance: MenuModel = MenuModel()}; return Singleton.instance }
    dynamic var menus   : [Sort]    = []
    var arr: [Sort] = []
    
    private override init() {
        super.init()
        self.initMenuArray()
    }
    
    func updateMenuArray(){
        let campus = Config.getCampusId()
        self.arr = []
        self.setCategories(campus)
        self.setDepartments(campus)
        self.setOrders()
        
        MenuModel.sharedInstance.menus = self.arr
    }
    
    func initMenuArray(){
        let campus = Config.getCampusId()
        
        self.setCategories(campus)
        self.setDepartments(campus)
        self.setOrders()
        
        self.menus = self.arr
    }

    
    func getMenuArrays() -> ([Sort],[Sort],[Sort]) {
        var cate: [Sort] = [], depa: [Sort] = [], order: [Sort] = []
        for sort in self.menus {
            switch sort.menu {
            case .category:     cate.append(sort); break
            case .department:   depa.append(sort); break
            case .order:        order.append(sort);break
            }
        }
        return (cate, depa, order)
    }
    
    func setMenuArray(arr: [Sort]){
        self.menus = arr
    }
    
    private func setCategories(campus: Int){
        self.arr.append(Sort(id: 100, name: "全て", imagePath: "zen", menu: .category))
        self.arr.append(Sort(id: 99, name: "未分類", imagePath: "未", menu: .category))
        if campus == CAMPUS.iizuka.val {
            self.arr.append(Sort(id: 0, name: "お知らせ", imagePath: "gaku", menu: .category))
            self.arr.append(Sort(id: 1, name: "奨学金", imagePath: "shou", menu: .category))
            self.arr.append(Sort(id: 2, name: "補講通知", imagePath: "ho", menu: .category))
            self.arr.append(Sort(id: 3, name: "休講通知", imagePath: "kyuu", menu: .category))
            self.arr.append(Sort(id: 4, name: "授業調整・試験", imagePath: "shi", menu: .category))
            self.arr.append(Sort(id: 5, name: "学生呼出", imagePath: "yobi", menu: .category))
            self.arr.append(Sort(id: 6, name: "時間割・講義室変更", imagePath: "hen", menu: .category))
            self.arr.append(Sort(id: 7, name: "各種変更手続き", imagePath: "te", menu: .category))
            self.arr.append(Sort(id: 8, name: "集中講義", imagePath: "shuu", menu: .category))
            self.arr.append(Sort(id: 9, name: "留学・語学学習支援", imagePath: "ryuu", menu: .category))
            self.arr.append(Sort(id: 10, name: "学部生情報", imagePath: "gaku", menu: .category))
            self.arr.append(Sort(id: 11, name: "大学院生情報", imagePath: "in", menu: .category))
        }
        self.arr.append(Sort(id: 12, name: "重要なお知らせ", imagePath: "重", menu: .category))
        self.arr.append(Sort(id: 13, name: "ニュース", imagePath: "ニ", menu: .category))
        self.arr.append(Sort(id: 14, name: "イベント", imagePath: "イ", menu: .category))
    }
    
    static func getCategoryWithId(val: String) -> Sort? {
        for menu in MenuModel.sharedInstance.menus {
            if String(menu.id) == val && menu.menu == .category { return menu }
        }
        return nil
    }
    
    private func setDepartments(campus: Int){
        self.arr.append(Sort(id: 0, name: "全て", imagePath: "all", menu: .department))
        if campus == CAMPUS.iizuka.val {
            self.arr.append(Sort(id: 1, name: "学部", imagePath: "faculty", menu: .department))
            self.arr.append(Sort(id: 2, name: "大学院", imagePath: "postgraduate", menu: .department))
            self.arr.append(Sort(id: 3, name: "知能情報", imagePath: "chinou", menu: .department))
            self.arr.append(Sort(id: 4, name: "電子情報", imagePath: "denshi", menu: .department))
            self.arr.append(Sort(id: 5, name: "システム創成", imagePath: "system", menu: .department))
            self.arr.append(Sort(id: 6, name: "機械情報", imagePath: "kikai", menu: .department))
            self.arr.append(Sort(id: 7, name: "生命情報", imagePath: "seimei", menu: .department))
        }
    }
    
    static func getDepartmentWithId(val: String) -> Sort? {
        for menu in MenuModel.sharedInstance.menus {
            if String(menu.id) == val && menu.menu == .department { return menu }
        }
        return nil
    }
    
    private func setOrders(){
        self.arr.append(Sort(id: 0, name: "新着順", imagePath: "", menu: .order))
        self.arr.append(Sort(id: 1, name: "日付が近い順", imagePath: "", menu: .order))
        self.arr.append(Sort(id: 2, name: "日付順", imagePath: "", menu: .order))
    }
}