//
//  CategoryModel.swift
//  kyutech
//
//  Created by shogo okamuro on 2/8/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
import SHUtil


class CategoryModel: NSObject {
    class var sharedInstance: CategoryModel { struct Singleton { static let instance: CategoryModel = CategoryModel()}; return Singleton.instance }
    dynamic var categorys   : [Category]    = []
    dynamic var departments : [Department]  = []
    dynamic var sortings    : [String]      = []
    
    private override init() {
        super.init()
        self.setCategories(CAMPUS.iizuka.val)
        self.setDepartments(CAMPUS.iizuka.val)
    }
    
    private func setCategories(campus: Int){
        self.categorys.append(Category(id: 100, name: "全て", imagePath: "zen"))
        self.categorys.append(Category(id: 99, name: "未分類", imagePath: "mi"))
        if campus == CAMPUS.iizuka.val {
            self.categorys.append(Category(id: 0, name: "お知らせ", imagePath: "gaku"))
            self.categorys.append(Category(id: 1, name: "奨学金", imagePath: "shou"))
            self.categorys.append(Category(id: 2, name: "補講通知", imagePath: "ho"))
            self.categorys.append(Category(id: 3, name: "休講通知", imagePath: "kyuu"))
            self.categorys.append(Category(id: 4, name: "授業調整・試験", imagePath: "shi"))
            self.categorys.append(Category(id: 5, name: "学生呼出", imagePath: "yobi"))
            self.categorys.append(Category(id: 6, name: "時間割・講義室変更", imagePath: "hen"))
            self.categorys.append(Category(id: 7, name: "各種変更手続き", imagePath: "te"))
            self.categorys.append(Category(id: 8, name: "集中講義", imagePath: "shuu"))
            self.categorys.append(Category(id: 9, name: "留学・語学学習支援", imagePath: "ryuu"))
            self.categorys.append(Category(id: 10, name: "学部生情報", imagePath: "gaku"))
            self.categorys.append(Category(id: 11, name: "大学院生情報", imagePath: "in"))
        }
        self.categorys.append(Category(id: 12, name: "重要なお知らせ", imagePath: "重"))
        self.categorys.append(Category(id: 13, name: "ニュース", imagePath: "ニ"))
        self.categorys.append(Category(id: 14, name: "イベント", imagePath: "イ"))
    }
    
    static func getCategoryWithId(val: String) -> Category? {
        for category in CategoryModel.sharedInstance.categorys {
            if String(category.id) == val { return category }
        }
        return nil
    }
    
    private func setDepartments(campus: Int){
        if campus == CAMPUS.iizuka.val {
            self.departments.append(Department(id: 0, name: "全て", imagePath: "all"))
            self.departments.append(Department(id: 1, name: "学部", imagePath: "faculty"))
            self.departments.append(Department(id: 2, name: "大学院", imagePath: "postgraduate"))
            self.departments.append(Department(id: 3, name: "知能情報", imagePath: "chinou"))
            self.departments.append(Department(id: 4, name: "電子情報", imagePath: "denshi"))
            self.departments.append(Department(id: 5, name: "システム創成", imagePath: "system"))
            self.departments.append(Department(id: 6, name: "機械情報", imagePath: "kikai"))
            self.departments.append(Department(id: 7, name: "生命情報", imagePath: "seimei"))
                
        }
    }
    static func getDepartmentWithId(val: String) -> Department? {
        for department in CategoryModel.sharedInstance.departments {
            if String(department.id) == val { return department }
        }
        return nil
    }
}