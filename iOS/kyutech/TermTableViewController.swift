//
//  TermTableViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 2/14/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

protocol TermPopOrverDelegate{
    func termSelectedWithIndexPath(term: Int)
}

class TermTableViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var delegate : LectureCollectionViewController?
    
    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: 300, height: 275)
        }
        set {
            super.preferredContentSize = newValue
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.termSelectedWithIndexPath(indexPath.row)
        NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: Config.userDefault.term)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = Term()[indexPath.row]
        cell.textLabel?.textAlignment = .Center
        return cell
    }
}
