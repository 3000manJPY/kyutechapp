//
//  SettingTableViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 3/11/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
import SHUtil
import SafariServices

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: SettingTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func openSafariView(str: String){
        let url = NSURL(string:str) ?? NSURL()
        let brow = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
        presentViewController(brow, animated: true, completion: nil)
    }
    
    func setHPName(cell: UITableViewCell) -> UITableViewCell {
        let campus = Config.getCampusId()
        switch campus {
        case CAMPUS.iizuka.val:     cell.textLabel?.text = "\(CAMPUS.iizuka.name)ホームページ";     break
        case CAMPUS.tobata.val:     cell.textLabel?.text = "\(CAMPUS.tobata.name)ホームページ";     break
        case CAMPUS.wakamatsu.val:  cell.textLabel?.text = "\(CAMPUS.wakamatsu.name)ホームページ";  break
        default: break
        }
        return cell
    }
    
    func openHP(){
        let campus = Config.getCampusId()
        switch campus {
        case CAMPUS.iizuka.val:     self.openSafariView(CAMPUS.iizuka.hp);      break
        case CAMPUS.tobata.val:     self.openSafariView(CAMPUS.tobata.hp);      break
        case CAMPUS.wakamatsu.val:  self.openSafariView(CAMPUS.wakamatsu.hp);   break
        default: break
        }
    }
    
    func changeCampusAlertController(){
        // インスタンス生成　styleはActionSheet.
        let campusId = Config.getCampusId()
        var campusName = ""
        if let campus = CAMPUS.geyNameById(String(campusId)) {
            campusName = campus
        }
        let myAlert = UIAlertController(title: "キャンパスを選択", message: "現在：\(campusName)", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        // アクションを生成.
        let tobata = UIAlertAction(title: CAMPUS.tobata.name, style: campusId == CAMPUS.tobata.val ? UIAlertActionStyle.Destructive : UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction!) in
            self.changeTheme(CAMPUS.tobata.val)

        })
        
        let iizuka = UIAlertAction(title: CAMPUS.iizuka.name, style: campusId == CAMPUS.iizuka.val ? UIAlertActionStyle.Destructive : UIAlertActionStyle.Default , handler: {
            (action: UIAlertAction!) in
            self.changeTheme(CAMPUS.iizuka.val)

        })
        
        let wakamatsu = UIAlertAction(title: CAMPUS.wakamatsu.name, style: campusId == CAMPUS.wakamatsu.val ? UIAlertActionStyle.Destructive : UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction!) in
            self.changeTheme(CAMPUS.wakamatsu.val)

        })
        
        let cansel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Cancel, handler: {
            (action: UIAlertAction!) in
        })
        
        // アクションを追加.
        myAlert.addAction(tobata)
        myAlert.addAction(iizuka)
        myAlert.addAction(wakamatsu)
        myAlert.addAction(cansel)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func changeTheme(campus :Int){
        NSUserDefaults.standardUserDefaults().setInteger(campus, forKey: Config.userDefault.campus)
        self.tableView.reloadData()
       
//        NoticeModel.sharedInstance.updateDate()
//        MenuModel.sharedInstance.updateMenuArray()
        self.tabBarController?.customAppearance()
        self.navigationController?.customAppearance()
        
        NSNotificationCenter.defaultCenter().postNotificationName(Config.notification.changeCampus, object: nil)
 
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 0: self.changeCampusAlertController();     break
        case 1: self.openSafariView(Config.padHP);      break
        case 2: self.openSafariView(Config.padHP);      break
        case 3: self.openSafariView(Config.padHP);      break
        case 4: self.openSafariView(CAMPUS.parentHP);   break
        case 5: self.openHP();                          break
        default:                                        break
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        switch indexPath.row {
        case 0: cell.textLabel?.text = "キャンパスの切り替え";    break
        case 1: cell.textLabel?.text = "お知らせ";              break
        case 2: cell.textLabel?.text = "このアプリについて";     break
        case 3: cell.textLabel?.text = "P&Dについて";           break
        case 4: cell.textLabel?.text = "九工大ホームページ";     break
        case 5: self.setHPName(cell);                         break
        default:
            break
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
}
