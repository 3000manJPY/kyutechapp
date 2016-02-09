//
//  MenuTableViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 2/8/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

enum SECTION: Int {
    case order = 0
    case category = 1
    case department = 2
    
    func toS() -> String {
        switch self{
        case .order : return "\(SECTION.order.rawValue)"
        case .category : return "\(SECTION.category.rawValue)"
        case .department : return "\(SECTION.department.rawValue)"
        }
    }
}

protocol CategoryDelegate{
    func checked(dict: [String:Bool])
}

class MenuTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var categories : [Category] = []
    var departments : [Department] = []
    var sortings: [String] = []
    
    var selectedCells:[String:Bool]=[String:Bool]()
    
    var select_image = UIImage(named: "category")
    var noselect_image = UIImage(named: "no_select")
    var nil_image = UIImage(named: "nil_image")
    
    var delegate: CategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCategories()
        self.settingTableView()
        self.defaultSelectCells()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setRepo()
    }
    
    //googleAnariticsを設定
    func setRepo(){
//        let tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: NSStringFromClass(self.classForCoder))
//        
//        let builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    //配列をセットする
    func setCategories(){
        self.categories = CategoryModel.sharedInstance.categorys
        self.departments = CategoryModel.sharedInstance.departments
        self.sortings = ["新着順","日付が近い順"]
    }
    
    //TableViewの設定をする
    func settingTableView(){
        let edgeInsets = UIEdgeInsetsMake(0, 0, 50, 0)
        self.tableView.contentInset = edgeInsets
        self.tableView.scrollIndicatorInsets = edgeInsets
    }
   
    //初期でチェックするセルを設定
    func defaultSelectCells(){
        self.selectedCells["0-0"] = true
        self.selectedCells["1-0"] = true
        self.selectedCells["2-0"] = true
    }
   
    //アンチェックする
    func setUnCheckImage(indexPath:NSIndexPath) -> UIImage{
        let image = UIImage(named:"checking")!
        if      indexPath.section == SECTION.order.rawValue      { return UIImage(named: "checking") ?? image }
        else if indexPath.section == SECTION.category.rawValue   { return self.nil_image ?? image }
        else if indexPath.section == SECTION.department.rawValue { return self.noselect_image ?? image }
        return image
    }
    
    //チェックする
    func setCheckImage(indexPath:NSIndexPath) -> UIImage{
        let image = UIImage(named: "checking")!
        if      indexPath.section == SECTION.order.rawValue      { return UIImage(named: "checking") ?? image }
        else if indexPath.section == SECTION.category.rawValue   { return self.select_image ?? image }
        else if indexPath.section == SECTION.department.rawValue { return UIImage(named: self.departments[indexPath.row].imagePath) ?? image }
        return image
    }
    
    //セルがチェックされているかを返す。なければfalseで作る
    func isSelected(indexPath: NSIndexPath) -> Bool {
        if let chk = self.selectedCells["\(indexPath.section)-\(indexPath.row)"] {
            return chk
        }else{
            self.selectedCells["\(indexPath.section)-\(indexPath.row)"] = false
            return false
        }
    }
}

//tableViewのdelegate + datasource
extension MenuTableViewController: UITableViewDelegate, UITableViewDataSource {
    //rowの数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section){
        case SECTION.category.rawValue:   return self.categories.count
        case SECTION.department.rawValue: return self.departments.count
        case SECTION.order.rawValue:      return self.sortings.count
        default: return 0
        }
    }
    //セクションの数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 3 }
    
    //cellを作る
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        guard let         name = cell.viewWithTag(100) as? UILabel,
                frontImageView = cell.viewWithTag(200) as? UIImageView,
                 backImageView = cell.viewWithTag(300) as? UIImageView else{ return UITableViewCell() }
        cell.backgroundColor = UIColor.clearColor()
        
        let selected = self.isSelected(indexPath)
        switch indexPath.section {
            
        case SECTION.order.rawValue:
            let sort = self.sortings[indexPath.row]
            name.text = sort
            frontImageView.image = nil
            if selected == false { backImageView.image = nil }
            else                 { backImageView.image = setCheckImage(indexPath) }
            break
            
        case SECTION.category.rawValue:
            let category = self.categories[indexPath.row] as Category
            name.text = category.name
            frontImageView.image = UIImage(named: category.imagePath)
            if selected == false { backImageView.image = setUnCheckImage(indexPath) }
            else                 { backImageView.image = setCheckImage(indexPath)   }
            break
            
        case SECTION.department.rawValue:
            let department = self.departments[indexPath.row] as Department
            name.text = department.name
            frontImageView.image = self.noselect_image
            if selected == false { backImageView.image = setUnCheckImage(indexPath) }
            else                 { backImageView.image = setCheckImage(indexPath) }
            break
        default: break
        }
        return cell
    }
    //セクションをカスタムする
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x:0, y:0, width: tableView.bounds.width, height: 50))
        // 背景色
        label.backgroundColor = UIColor.whiteColor()
        // 文字色
        label.textColor =  UIColor(red: 0.0, green: 138.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
        var title = "no name"
        switch (section){
        case SECTION.order.rawValue:        title = "　並び替え";        break
        case SECTION.category.rawValue:     title = "　カテゴリ";        break
        case SECTION.department.rawValue:   title = "　学部 / 大学院";   break
        default: title = "no name";break
        }
        label.text = title
        label.font = UIFont.italicSystemFontOfSize(20)
        return label
    }
    
    //ヘッダーの高さを決定
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 60 }
    //セルが選択された時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //チェックを全て自分以外はずすとき
        if indexPath.section == SECTION.order.rawValue || indexPath.row == 0 {
            let chk = self.selectedCells["\(indexPath.section)-\(0)"]
            if chk == false {
                self.selectedCells["\(indexPath.section)-\(0)"] = true
                switch indexPath.section {
                case SECTION.order.rawValue:        for i in 1..<self.sortings.count   { self.selectedCells["\(SECTION.order.rawValue)-\(i)"] = false }; break
                case SECTION.category.rawValue:     for i in 1..<self.categories.count { self.selectedCells["\(SECTION.category.rawValue)-\(i)"] = false }; break
                case SECTION.department.rawValue:   for i in 1..<self.departments.count{ self.selectedCells["\(SECTION.department.rawValue)-\(i)"] = false }; break
                default: break
                }
            }
        }
        self.selectedCells["\(indexPath.section)-\(0)"] = false
        if let chk = self.selectedCells["\(indexPath.section)-\(indexPath.row)"] { self.selectedCells["\(indexPath.section)-\(indexPath.row)"] = !chk  }
        else                                                                     { self.selectedCells["\(indexPath.section)-\(indexPath.row)"] = false }
        
        self.delegate?.checked(self.selectedCells)
        self.tableView.reloadData()
    }
}

