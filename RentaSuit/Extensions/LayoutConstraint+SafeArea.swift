//
//  LayoutConstraint+SafeArea.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/15/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    @IBInspectable var safeAreaIsFirstItem: Bool {
        get {
            return false
        }
        set(safeAreaIsFirstItem) {
            if !safeAreaIsFirstItem {
                return
            }
            if SYSTEM_VERSION_LESS_THAN(version: "11.0") {
                if firstAttribute == .top {
                    constant -= 20
                }
            }
        }
    }
    @IBInspectable var safeAreaIsSecondItem: Bool {
        get {
            return false
        }
        set(safeAreaIsSecondItem) {
            if !safeAreaIsSecondItem {
                return
            }
            if SYSTEM_VERSION_LESS_THAN(version: "11.0") {
                if secondAttribute == .top {
                    constant += 20
                }
            }
        }
    }
}

fileprivate func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedAscending
}
