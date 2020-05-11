//
//  ItemCell.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/25/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
enum Action {
    case add
    case edit
    case delete
}
protocol CellActionDelegate {
    func didRequest(_ cell :UITableViewCell ,_ action : Action)
}

class ItemCell: UITableViewCell {

    @IBOutlet weak var designerValueLabel: UILabel!
    @IBOutlet weak var seasonValueLabel: UILabel!
    @IBOutlet weak var categoryValueLabel: UILabel!
    @IBOutlet weak var locationValueLabel: UILabel!
    @IBOutlet weak var sizeValueLabel: UILabel!
    @IBOutlet weak var colorValueLabel: UILabel!
  
    @IBOutlet weak var productNameValueLabel: UILabel!
    @IBOutlet weak var deliveryOptionValueLabel: UILabel!
    @IBOutlet weak var rentfromValueLabel: UILabel!
    @IBOutlet weak var rentUntilValueLabel: UILabel!
    @IBOutlet weak var retailPriceValueLabel: UILabel!
    @IBOutlet weak var shippingValueLabel: UILabel!
    @IBOutlet weak var pricePerDayValueLabel: UILabel!
    @IBOutlet weak var daysValueLabel: UILabel!
    @IBOutlet weak var rentValueLabel: UILabel!
    @IBOutlet weak var cleaningPriceValueLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    var delegate : CellActionDelegate?
    
    func setUp(wish : Wish) {
        self.designerValueLabel.text = wish.designer
        self.sizeValueLabel.text = wish.size
        self.seasonValueLabel.text = wish.season
        self.locationValueLabel.text = wish.location
        self.colorValueLabel.text = wish.color
        self.categoryValueLabel.text = Category.categoryWithId(wish.category)
        
        if (wish.picture != nil) {
            let urlwithPercentEscapes =  (kBaseUrlImage + wish.picture!).addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let url:URL = URL(string:urlwithPercentEscapes!)!
            self.itemImage.setImageWith(url, placeholderImage: UIImage(named: "placeholder-test"))
        }
    }
    
    func setUp(cart : Cart) {
        self.productNameValueLabel.text = cart.productDetail.name
        self.deliveryOptionValueLabel.text = cart.deliveryOption
        self.rentfromValueLabel.text = cart.rentalStartDate
        self.rentUntilValueLabel.text = cart.rentalEndDate
        self.retailPriceValueLabel.text = cart.deliveryOption
        self.shippingValueLabel.text = "0"
        self.pricePerDayValueLabel.text = cart.productDetail.price
        self.daysValueLabel.text = String(Int(cart.total)! / Int(cart.productDetail.price)!)
        self.rentValueLabel.text = cart.total
        self.cleaningPriceValueLabel.text = cart.deliveryOption
        self.totalValueLabel.text = cart.deliveryOption
        
        if (cart.productDetail.picture != nil) {
            let urlwithPercentEscapes =  (kBaseUrlImage + cart.productDetail.picture).addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let url:URL = URL(string:urlwithPercentEscapes!)!
            self.itemImage.setImageWith(url, placeholderImage: UIImage(named: "placeholder-test"))
        }
    }
    
    
    @IBAction func didTapDelete(_ sender : UIButton) {
        if nil != self.delegate {
            self.delegate?.didRequest(self, .delete)
        }
    }

}
