//
//  PickableDataTextField.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/17/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class PickableDataTextField: PickableValuesTextField, UIPickerViewDelegate, UIPickerViewDataSource {

    var picker : UIPickerView?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(PickableDataTextField.reloadData), for: .editingDidBegin)
    }
    
    @objc func reloadData() {
        self.isUserInteractionEnabled = !(dataSet == nil || dataSet?.count == 0)
        setUpInputMethods()
    }
    
    override func setUpInputMethods() {
        if nil == picker {
            picker = UIPickerView()
        }
        picker?.delegate = self
        picker?.dataSource = self
        
        self.inputView = picker
        
        switch extras {
        case .done:
            self.inputAccessoryView =  UIToolbar.ToolbarPikerWithDone(doneSelector: #selector(PickableDataTextField.doneSelector))
            break
        case .next:
            self.inputAccessoryView =  UIToolbar.ToolbarPikerWithNext(nextSelector: #selector(PickableDataTextField.nextSelector))
            break
        case .both:
            self.inputAccessoryView =  UIToolbar.ToolbarPikerWithNextAndDone(nextSelector: #selector(PickableDataTextField.nextSelector),
                                                                             doneSelector: #selector(PickableDataTextField.doneSelector))
            break
        case .none:
            break
        }
        
        // if already has a value
        
        let idx = dataSet?.firstIndex(where: { (elem) -> Bool in
            lastSelected?.isEqual(elem) ?? false
        })
        if idx != nil && idx != NSNotFound {
            picker?.selectRow(idx ?? 0, inComponent: 0, animated: false)
        }
    }
    
    @objc func doneSelector() {
        if nil != pickableDelegate {
            pickableDelegate?.didRequestDone(sender: self)
        }
    }
    
    @objc func nextSelector() {
        if nil != pickableDelegate {
            pickableDelegate?.didRequestNext(sender: self)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (dataSet != nil) ? (dataSet?.count)! : 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let elem = dataSet![row]
        if elem is String {
            return elem as! String
        }
        return "others"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.lastSelected = dataSet?[row]
        if nil != pickableDelegate {
            pickableDelegate?.didSelectValue(sender: self, value: dataSet?[row])
        }
    }
    
}
