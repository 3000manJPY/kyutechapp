//
//  MenuTableViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 2/8/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

class MenuTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var categories : [Category] = []
    var departments : [Department] = []
    
    var selectedCells:[String:Bool]=[String:Bool]()
    
    var select_image = UIImage(named: "category")
    var noselect_image = UIImage(named: "no_select")
    var nil_image = UIImage(named: "nil_image")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categories = CategoryModel.sharedInstance.categorys
        self.departments = CategoryModel.sharedInstance.departments
        let edgeInsets = UIEdgeInsetsMake(0, 0, 50, 0)
        self.tableView.contentInset = edgeInsets
        self.tableView.scrollIndicatorInsets = edgeInsets
        
        self.selectedCells["0-0"] = true
        self.selectedCells["1-0"] = true

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        let tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: NSStringFromClass(self.classForCoder))
//        
//        let builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    func setImageForIndexpath(indexPath:NSIndexPath, tableViewCell cell:UITableViewCell, withKey key:String){
        if let backImageView = cell.viewWithTag(300) as? UIImageView {
            if indexPath.section == 0 {
                if backImageView.image?.imageAsset == self.select_image?.imageAsset {
                    backImageView.image = setUnCheckImage(indexPath)
                    selectedCells.removeValueForKey(key)
                }else{
                    backImageView.image = setCheckImage(indexPath)
                    selectedCells[key] = true
                }
            }else if indexPath.section == 1 {
                if backImageView.image?.imageAsset == self.noselect_image?.imageAsset {
                    backImageView.image = setCheckImage(indexPath)
                    selectedCells[key] = true
                }else{
                    selectedCells.removeValueForKey(key)
                    backImageView.image = setUnCheckImage(indexPath)
                }
            }
            self.isSelectedCells(indexPath)
        }
    }
    
    func isSelectedCells(indexPath: NSIndexPath) {
        var pre = ""
        if      indexPath.section == 0 { pre = "0" }
        else if indexPath.section == 1 { pre = "1"
        }else{ return }
        
        for (key,val) in self.selectedCells {
            if key.hasPrefix(pre) {
                if key == "\(indexPath.section)-0" { continue }
                self.selectedCells["\(indexPath.section)-0"] = false
                self.tableView.reloadData()
                return
            }
        }
        self.selectedCells["\(indexPath.section)-0"] = true
        self.tableView.reloadData()
    }
    func setUnCheckImage(indexPath:NSIndexPath) -> UIImage{
        var image : UIImage!
        if indexPath.section == 0 {
            image = self.nil_image
            return image
        }else if indexPath.section == 1 {
            image = self.noselect_image
            return image
        }
        return image
    }
    func setCheckImage(indexPath:NSIndexPath) -> UIImage{
        var image : UIImage!
        if indexPath.section == 0 {
            image = self.select_image
            return image
            
        }else if indexPath.section == 1 {
            let dep = self.departments[indexPath.row]
            image = UIImage(named: dep.imagePath)
            return image
        }
        
        return image
    }
 
    
}

extension MenuTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section){
        case 0:
            return self.categories.count
        case 1:
            return self.departments.count
        default:
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        if let name = cell.viewWithTag(100) as? UILabel,
            checkImageView = cell.viewWithTag(200) as? UIImageView,
            backImageView = cell.viewWithTag(300) as? UIImageView {
                cell.backgroundColor = UIColor.clearColor()
                if indexPath.section == 0 {
                    let category = self.categories[indexPath.row] as Category
                    name.text = category.name
                    checkImageView.image = UIImage(named: "\(category.imagePath)")
                }else if indexPath.section == 1 {
                    let department = self.departments[indexPath.row] as Department
                    name.text = department.name
                    checkImageView.image = self.noselect_image
                }
                let key = "\(indexPath.section)-\(indexPath.row)"
                if indexPath.section == 0 {
                    if let selected = selectedCells[key]{
                        if selected == false {
                            backImageView.image = setUnCheckImage(indexPath)
                        }else{
                            backImageView.image = setCheckImage(indexPath)
                        }
                    }else{
                        backImageView.image = setUnCheckImage(indexPath)
                    }
                }else if indexPath.section == 1 {
                    if let selected = selectedCells[key]{
                        if selected == false {
                            backImageView.image = setUnCheckImage(indexPath)
                            
                        }else{
                            backImageView.image = setCheckImage(indexPath)
                        }
                    }else{
                        backImageView.image = setUnCheckImage(indexPath)
                        
                    }
                }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x:0, y:0, width: tableView.bounds.width, height: 50))
        
        // 背景色
        label.backgroundColor = UIColor.whiteColor()
        
        // 文字色
        label.textColor =  UIColor(red: 0.0, green: 138.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
        
        
        var title = "no name"
        switch (section){
        case 0:
            title = "　カテゴリ"
            break
            
        case 1:
            title = "　学部 / 大学院"
            break
        default:
            title = "no name"
            break
        }
        
        label.text = title
        label.font = UIFont.italicSystemFontOfSize(20)
        
        return label
    }
    
    //ヘッダーの高さを決定
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 0 {
            for (key,val) in self.selectedCells {
                let section : Int = Int(String(key[key.startIndex]))!
                let row = Int(key.substringFromIndex(key.startIndex.advancedBy(2)))
                if row != 0 && indexPath.section == section {
                    self.selectedCells.removeValueForKey(key)
                    let path = NSIndexPath(forRow: row!, inSection: section)
                    isSelectedCells(path)
                }
            }
        }else{
            
        }
        let key = "\(indexPath.section)-\(indexPath.row)"
        setImageForIndexpath(indexPath, tableViewCell: cell, withKey: key)
    }
}

