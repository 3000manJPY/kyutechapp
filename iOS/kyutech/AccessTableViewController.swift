//
//  AccessTableViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 3/19/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import Foundation
import UIKit
import SHUtil
import RealmSwift

protocol AccessScrollViewDelegate {
    func accessScrollViewWillBeginDragging(scrollView: UIScrollView)
    func accessScrollViewDidScroll(scrollView: UIScrollView)
    func accessScrollViewWillBeginDecelerating(scrollView: UIScrollView)
 
}

class AccessTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: AccessTableView!
    var timetables: List<Timetable>?
    var delegate:   AccessScrollViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension AccessTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timetables?.count ?? 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}

extension AccessTableViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.delegate?.accessScrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.delegate?.accessScrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        self.delegate?.accessScrollViewWillBeginDecelerating(scrollView)
    }
}