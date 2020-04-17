//
//  PickableDateTextField.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/17/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class PickableDateTextField: PickableValuesTextField {

    var picker : UIDatePicker?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(PickableDataTextField.reloadData), for: .editingDidBegin)
    }
    
    @objc func reloadData() {
        setUpInputMethods()
    }
    
    override func setUpInputMethods() {
        if nil == picker {
            picker = UIDatePicker()
            picker?.datePickerMode = .date
            picker!.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        }
        
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
        
        guard let dateString = lastSelected as? String else { return }
        guard let dateFromString = dateString.fromYYYYMMJJText else { return }
        picker?.setDate(dateFromString, animated: false)
        
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
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        self.lastSelected = sender.date.asYYYYMMJJText as AnyObject
        if nil != pickableDelegate {
            pickableDelegate?.didSelectValue(sender: self, value: self.lastSelected)
        }
    }
    
}
