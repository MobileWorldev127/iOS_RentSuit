//
//  RentaInfoWindow.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/15/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class RentaInfoWindow: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationInfoLabel: UILabel!
    @IBOutlet weak var cleanerImage: UIImageView!
    class func clone() -> RentaInfoWindow {
        let view:RentaInfoWindow = Bundle.main.loadNibNamed("RentaInfoWindow", owner: self, options: nil)?.first as! RentaInfoWindow
        return view
    }
    
    func setUp(_ cleaner : Cleaner) {
        self.locationInfoLabel.text = cleaner.location
        self.nameLabel.text = cleaner.shopName
    }
}
