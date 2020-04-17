//
//  SlectableButton.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/18/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation

import UIKit

protocol Checkable {
    func doCheck()
    func doUnCheck()
}

class CheckableButton: UIButton, Checkable {
    
    var isChecked = false
    
    func doCheck() {
        
    }
    
    func doUnCheck() {
        
    }
}

class SelectableButton: CheckableButton {
    
    @IBInspectable
    var onTextColor: UIColor = UIColor.yellowApp()
    
    @IBInspectable
    var offTextColor: UIColor = UIColor.greyApp()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(didClick(_:)), for: .touchUpInside)
        self.doUnCheck()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(didClick(_:)), for: .touchUpInside)
        self.doUnCheck()
    }
    
    @objc func didClick(_ sender:UIButton) {
        if isChecked {
            doUnCheck()
        }else{
            doCheck()
        }
    }
    
    override func doUnCheck() {
        self.setTitleColor(self.offTextColor, for: .normal)
    }
    
    override func doCheck() {
        self.setTitleColor(self.onTextColor, for: .normal)
    }
}
