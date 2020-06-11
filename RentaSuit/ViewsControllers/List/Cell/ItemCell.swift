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

    @IBOutlet weak var ownerValueLabel: UILabel!
    @IBOutlet weak var colorValueLabel: UILabel!
    @IBOutlet weak var sizeValueLabel: UILabel!
    @IBOutlet weak var priceValueLabel: UILabel!
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
        self.productNameValueLabel.text = wish.name
        self.ownerValueLabel.text = wish.owner
        self.colorValueLabel.text = wish.color
        self.sizeValueLabel.text = wish.size
        self.priceValueLabel.text = "$" + wish.retailPrice! + "/day"
        
        if (wish.picture != nil) {
            let urlwithPercentEscapes =  (wish.picture!).addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let url:URL = URL(string:urlwithPercentEscapes!)!
            self.itemImage.setImageWith(url, placeholderImage: UIImage(named: "placeholder-test"))
        }
    }
    
    func setUp(cart : Cart) {
      Wish.getItemDetails(String(cart.productID)) { (detail, code) in
          if nil != detail {
              self.productNameValueLabel.text = cart.productDetail.name
              if (cart.deliveryOption == "Ups"){
                self.deliveryOptionValueLabel.text = "Pick up from UPS"
              }else {
                self.deliveryOptionValueLabel.text = cart.deliveryOption
              }
            
              
              self.rentfromValueLabel.text = cart.rentalStartDate
              self.rentUntilValueLabel.text = cart.rentalEndDate
              self.retailPriceValueLabel.text = detail?.retailPrice
              if (cart.shippingInfo == nil){
                self.shippingValueLabel.text = "0"
              }else {
                self.shippingValueLabel.text = String(cart.shippingInfo.hashValue)
              }
              self.pricePerDayValueLabel.text = String(cart.productDetail.price)
              self.daysValueLabel.text = String(cart.total / cart.productDetail.price)
              self.rentValueLabel.text = String(cart.total)
              if (detail?.cleansingPrice == ""){
                self.cleaningPriceValueLabel.text = detail?.cleansingPrice
              } else {
                self.cleaningPriceValueLabel.text = "NP"
              }
              self.totalValueLabel.text = String(Int((detail?.retailPrice)!)! + cart.total)
              
              if (cart.productDetail.picture != nil) {
                  let urlwithPercentEscapes =  (cart.productDetail.picture).addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                  let url:URL = URL(string:urlwithPercentEscapes!)!
                  self.itemImage.setImageWith(url, placeholderImage: UIImage(named: "placeholder-test"))
              }
          }
      }
      

    }
    
    
    @IBAction func didTapDelete(_ sender : UIButton) {
        if nil != self.delegate {
            self.delegate?.didRequest(self, .delete)
        }
    }

}
