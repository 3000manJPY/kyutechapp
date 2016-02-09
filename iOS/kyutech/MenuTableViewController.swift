//
//  MenuTableViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 2/8/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

enum SECTION: Int {
    case order      = 0
    case category   = 1
    case department = 2
    
    func toS() -> String {
        switch self{
        case .order         : return "\(SECTION.order.rawValue)"
        case .category      : return "\(SECTION.category.rawValue)"
        case .department    : return "\(SECTION.department.rawValue)"
        }
    }
}


class MenuTableViewController: UIViewController {
    @IBOutlet weak var menuTableView: MenuTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setRepo()
        MenuModel.sharedInstance.addObserver(self, forKeyPath: "menus", options: [.New, .Old], context: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MenuModel.sharedInstance.removeObserver(self, forKeyPath: "menus")
    }
    
    //googleAnariticsを設定
    func setRepo(){
//        let tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: NSStringFromClass(self.classForCoder))
//        
//        let builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath == "menus"){
            if let arr = change?["new"] as? [Sort] {
                self.menuTableView.menus = arr
                self.menuTableView.reloadData()
            }
        }
    }
}

//tableViewのdelegate + datasource
extension MenuTableViewController: UITableViewDelegate, UITableViewDataSource {
    //rowの数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.menuTableView.arrayForSection(section).count }
    //セクションの数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 3 }
    //cellを作る
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell = self.menuTableView.setParameters(cell, indexPath: indexPath)
        return cell
    }
    //セクションをカスタムする
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return self.menuTableView.createSectionView(section) }
    
    //ヘッダーの高さを決定
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 60 }
    //セルが選択された時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.menuTableView.deselectRowAtIndexPath(indexPath, animated: true)
        //チェックを全て自分以外はずすとき
//        if indexPath.section == SECTION.order.rawValue || indexPath.row == 0 {
//            let chk = self.selectedCells["\(indexPath.section)-\(0)"]
//            if chk == false {
//                self.selectedCells["\(indexPath.section)-\(0)"] = true
//                switch indexPath.section {
//                case SECTION.order.rawValue:        for i in 1..<self.sortings.count   { self.selectedCells["\(SECTION.order.rawValue)-\(i)"] = false }; break
//                case SECTION.category.rawValue:     for i in 1..<self.categories.count { self.selectedCells["\(SECTION.category.rawValue)-\(i)"] = false }; break
//                case SECTION.department.rawValue:   for i in 1..<self.departments.count{ self.selectedCells["\(SECTION.department.rawValue)-\(i)"] = false }; break
//                default: break
//                }
//            }
//        }
//        self.selectedCells["\(indexPath.section)-\(0)"] = false
//        if let chk = self.selectedCells["\(indexPath.section)-\(indexPath.row)"] { self.selectedCells["\(indexPath.section)-\(indexPath.row)"] = !chk  }
//        else                                                                     { self.selectedCells["\(indexPath.section)-\(indexPath.row)"] = false }
//        
//        self.delegate?.checked(self.selectedCells)
        
        switch indexPath.section {
        case SECTION.category.rawValue:
            self.menuTableView.categories[indexPath.row].check = !self.menuTableView.categories[indexPath.row].check
            break
        case SECTION.department.rawValue:
            self.menuTableView.departments[indexPath.row].check = !self.menuTableView.departments[indexPath.row].check
            break
        case SECTION.order.rawValue:
            self.menuTableView.orders[indexPath.row].check = !self.menuTableView.orders[indexPath.row].check
            break
        default: break
        }
        MenuModel.sharedInstance.setMenuArray(self.menuTableView.categories + self.menuTableView.departments + self.menuTableView.orders)
    }
}

