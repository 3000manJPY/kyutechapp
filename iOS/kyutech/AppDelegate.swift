//
//  AppDelegate.swift
//  kyutech
//
//  Created by shogo okamuro on 1/30/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import SHUtil
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.setAppearance()
        
        Fabric.with([Crashlytics.self])
        // TODO: Move this to where you establish a user session
//        self.logUser()
        self.realmMigration()
        return true
    }
    
    func realmMigration(){
        let config = Realm.Configuration(
            schemaVersion: 6,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 6) {}
        })
        Realm.Configuration.defaultConfiguration = config
    }
    
    func logUser() {
        // TODO: Use the current user's information
//        Crashlytics.sharedInstance().setUserEmail("user@fabric.io")
//        Crashlytics.sharedInstance().setUserIdentifier("12345")
//        Crashlytics.sharedInstance().setUserName("Test User")
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        NSNotificationCenter.defaultCenter().postNotificationName(Config.notification.applicationDidEnterBackground, object: nil)
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        NSNotificationCenter.defaultCenter().postNotificationName(Config.notification.applicationWillEnterForeground, object: nil)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func setAppearance(){
        UITableView.appearance().layoutMargins = UIEdgeInsetsZero
        UITableViewCell.appearance().layoutMargins = UIEdgeInsetsZero
        
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if url.scheme == "kyutechapp" {
            guard let host = url.host else { return false }
//            guard let query = url.query else { return false }
            switch host {
            case "notice" :
                var dict = url.parseGetArgments()
                dict["id"] = "11"
                NSNotificationCenter.defaultCenter().postNotificationName(Config.notification.notice.open, object: nil, userInfo: dict)
                break
            case "lectures" :break
            case "access"   :break
            case "etc"      :break
            default: break
            }
            return true
        }
        return false
    }
}

