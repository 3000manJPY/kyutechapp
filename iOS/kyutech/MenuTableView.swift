//
//  MenuTableView.swift
//  kyutech
//
//  Created by shogo okamuro on 2/10/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

class MenuTableView: UITableView {
    let selectImage    = UIImage(named: "category")!
    let noselectImage  = UIImage(named: "no_select")!
    let nilImage       = UIImage(named: "nil_image")!
    
    var menus       : [Sort] = []
    var categories  : [Sort] = []
    var departments : [Sort] = []
    var orders      : [Sort] = []
    
    override convenience init(frame: CGRect, style: UITableViewStyle) {
        self.init()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setMenues()
        self.settingTableView()
        self.defaultSelectCells()

    }
    
    //配列をセットする
    func setMenues(){
        (self.categories,self.departments,self.orders) = MenuModel.sharedInstance.getMenuArrays()
    }
    //TableViewの設定をする
    func settingTableView(){
        let edgeInsets = UIEdgeInsetsMake(0, 0, 50, 0)
        self.contentInset             = edgeInsets
        self.scrollIndicatorInsets    = edgeInsets
    }
    //初期でチェックするセルを設定
    func defaultSelectCells(){
        self.categories[0].check    = true
        self.departments[0].check   = true
        self.orders[0].check        = true
    }
    
    //BackImageViewアンチェックする
    func setBackImageUnCheck(indexPath:NSIndexPath) -> UIImage{
        switch indexPath.section {
        case SECTION.category.rawValue:     return self.nilImage
        case SECTION.department.rawValue:   return self.nilImage
        case SECTION.order.rawValue:        return self.noselectImage
        default: return self.nilImage
        }
    }
    
    //BackImageViewチェックする
    func setBackImageCheck(indexPath:NSIndexPath) -> UIImage{
        let menu = self.arrayForSection(indexPath.section)[indexPath.row]
        switch indexPath.section {
        case SECTION.category.rawValue:     return self.selectImage
        case SECTION.department.rawValue:   return UIImage(named: menu.imagePath) ?? self.nilImage
        case SECTION.order.rawValue:        return UIImage(named: menu.imagePath) ?? self.nilImage
        default: return self.nilImage
        }
    }
    
    //FrontImageViewに画像をセット
    func setFrontImage(indexPath:NSIndexPath) -> UIImage{
        let menu = self.arrayForSection(indexPath.section)[indexPath.row]
        switch indexPath.section {
        case SECTION.category.rawValue:     return UIImage(named: menu.imagePath) ?? self.nilImage
        case SECTION.department.rawValue:   return self.noselectImage
        case SECTION.order.rawValue:        return UIImage()
        default: return self.nilImage
        }
    }

    func setParameters(cell: UITableViewCell, indexPath: NSIndexPath) -> UITableViewCell {
        guard let name = cell.viewWithTag(100)  as? UILabel,
        frontImageView = cell.viewWithTag(200)  as? UIImageView,
         backImageView = cell.viewWithTag(300)  as? UIImageView else{ return UITableViewCell() }
        name.text               = self.arrayForSection(indexPath.section)[indexPath.row].name
        frontImageView.image    = self.setFrontImage(indexPath)
        if self.isSelected(indexPath) == false { backImageView.image = self.setBackImageUnCheck(indexPath) }
        else                 { backImageView.image = self.setBackImageCheck(indexPath) }
        
        return cell
        
    }
    func isSelected(indexPath: NSIndexPath) -> Bool { return self.arrayForSection(indexPath.section)[indexPath.row].check }
    
    func arrayForSection(section: Int) -> [Sort] {
        switch section {
        case SECTION.category.rawValue:     return self.categories
        case SECTION.department.rawValue:   return self.departments
        case SECTION.order.rawValue:        return self.orders
        default:                            return []
        }
    }
    
    func setArrayForSection(array: [Sort], section: Int){
        switch section {
        case SECTION.category.rawValue:     self.categories     = array; break
        case SECTION.department.rawValue:   self.departments    = array; break
        case SECTION.order.rawValue:        self.orders         = array; break
        default:                            return
        }
        MenuModel.sharedInstance.setMenuArray(self.categories + self.departments + self.orders)
    }

    func createSectionView(section: Int) -> UILabel {
        let label = UILabel(frame: CGRect(x:0, y:0, width: self.bounds.width, height: 50))
        label.backgroundColor = UIColor.whiteColor()
        label.textColor =  UIColor(red: 0.0, green: 138.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
        switch (section){
        case SECTION.order.rawValue:        label.text = "　並び替え";        break
        case SECTION.category.rawValue:     label.text = "　カテゴリ";        break
        case SECTION.department.rawValue:   label.text = "　学部 / 大学院";   break
        default: label.text = "no name";break
        }
        label.font = UIFont.italicSystemFontOfSize(20)
        return label
    }
}