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
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell { return self.menuTableView.setParameters(tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath), indexPath: indexPath) }
    //セクションをカスタムする
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return self.menuTableView.createSectionView(section) }
    //ヘッダーの高さを決定
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 60 }
    //セルが選択された時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.menuTableView.deselectRowAtIndexPath(indexPath, animated: true)
        let arr = self.menuTableView.arrayForSection(indexPath.section)
        arr[indexPath.row].check = !arr[indexPath.row].check
        //チェックを全て自分以外はずすとき
        if indexPath.section != SECTION.order.rawValue && indexPath.row == 0 {
            arr[0].check = true
            for i in 1..<arr.count { arr[i].check = false }
        }else if indexPath.section == SECTION.order.rawValue {
            for i in 0..<arr.count { arr[i].check = false }
            arr[indexPath.row].check = true
        }else{ arr[0].check = false }
        if self.isAllNoCheck(arr) { arr[0].check = true }

        self.menuTableView.setArrayForSection(arr, section: indexPath.section)
    }
    //全てチェックがない状態かどうか
    func isAllNoCheck(arr: [Sort]) -> Bool {
        for menu in arr { if menu.check { return false } }
        return true
    }
}

