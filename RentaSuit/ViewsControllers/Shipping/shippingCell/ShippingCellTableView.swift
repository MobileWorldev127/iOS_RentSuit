//
//  ShippingCellTableView.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 19/11/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class ShippingCellTableView: UITableViewCell {

    @IBOutlet weak var shippingPriceLabel: UILabel!
    @IBOutlet weak var shippingItemLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellWith(shipping:Shipping)  {
        self.shippingItemLabel.text = shipping.name
        self.shippingPriceLabel.text = shipping.value
    }
    
}
