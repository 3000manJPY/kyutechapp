//
//  AccessPickerViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 3/16/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

protocol AccessPickerDelegate {
    func resultObject(object: (String,Bool,Int?) ,id: Int?, mode: AccessPickerMode)
}

class AccessPickerViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    var list:   [(String,Bool,Int?)] = []
    var delegate:   AccessPickerDelegate?
    var mode: AccessPickerMode!
    var selectId: Int? = nil
    @IBAction func DoneTapd(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.resultObject(self.list[self.pickerView.selectedRowInComponent(0)] ,id: self.list[self.pickerView.selectedRowInComponent(0)].2, mode: self.mode)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //        [picker selectRow:0 inComponent:0 animated:YES];
        
        
        //        self.pickerView.selectRow(self.selectId ?? 0, inComponent: 0, animated: false)
    }
    
}

extension AccessPickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.list.count
    }
    
    //    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //        if self.list[row].1 {
    //            return self.list[row].0
    //        }else{
    //            return self.list[row].0
    //        }
    //    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label = UILabel()
        label.text = self.list[row].0
        label.font = UIFont.systemFontOfSize(20)
        label.textAlignment = .Center
        if self.list[row].1 {
            label.textColor = UIColor.redColor()
        }else{
            label.textColor = UIColor.blackColor()
        }
        return label
    }
}