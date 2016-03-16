//
//  AccessPickerViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 3/16/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

class AccessPickerViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    @IBAction func DoneTapd(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension AccessPickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "asdfasf"
    }
}