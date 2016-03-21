//
//  AccessPickerViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 3/16/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

protocol AccessPickerDelegate {
    func resultObject(object: String ,index: Int, mode: AccessPickerMode)
}

class AccessPickerViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    var list:   [String] = []
    var delegate:   AccessPickerDelegate?
    var mode: AccessPickerMode!
    var selectIndex = 0
    @IBAction func DoneTapd(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.resultObject(self.list[self.pickerView.selectedRowInComponent(0)] ,index: self.pickerView.selectedRowInComponent(0), mode: self.mode)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        [picker selectRow:0 inComponent:0 animated:YES];

        self.pickerView.selectRow(self.selectIndex, inComponent: 0, animated: false)
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