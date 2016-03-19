//
//  AccessPickerViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 3/16/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

protocol AccessPickerDelegate {
    func resultIndex(index: Int, mode: AccessPickerMode)
}

class AccessPickerViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    var list:   [String] = []
    var delegate:   AccessPickerDelegate?
    var mode: AccessPickerMode!
    @IBAction func DoneTapd(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.resultIndex(self.pickerView.selectedRowInComponent(0), mode: self.mode)
    }
    
}

extension AccessPickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.list.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.list[row]
    }
}