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
    var timetables: [HourMinits] = []
    var delegate:   AccessScrollViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    internal func onClickButton(sender: UIButton){
       SHprint("tap\(sender.tag)")
    }
}

extension AccessTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let stackView = cell.viewWithTag(100) as? UIStackView
        let hour =      cell.viewWithTag(200) as? UILabel
        let hm = self.timetables[indexPath.row]
        hour?.text = "   \(hm.h)時"
        for num in 0..<5 {
            //TODO: 5個以上ならばstackViewにaddする必要がある
            let str = hm.m.count > num ? String(hm.m[num]) : ""
            let btn = stackView?.arrangedSubviews[num + 1] as? UIButton
            btn?.setTitle(str, forState: .Normal)
            btn?.addTarget(self, action: #selector(AccessTableViewController.onClickButton(_:)), forControlEvents: .TouchUpInside)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timetables.count
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