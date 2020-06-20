//
//  ItemCell.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/25/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import Cosmos

enum Action {
    case add
    case edit
    case delete
}
protocol CellActionDelegate {
    func didRequest(_ cell :UITableViewCell ,_ action : Action)
    func didEditItem(_ cell :UITableViewCell ,_ action : Action)
    func didRemoveItem(_ cell :UITableViewCell ,_ action : Action)
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
  
    @IBOutlet weak var rentedProductImage: UIImageView!
    @IBOutlet weak var rentedProductOwnerImage: UIImageView!
    @IBOutlet weak var rentedProductNameLabel: UILabel!
    @IBOutlet weak var rentedProductPriceLabel: UILabel!
    @IBOutlet weak var rentedProductOwnerNameLabel: UILabel!
    @IBOutlet weak var rentedProductStatusLabel: UILabel!
    @IBOutlet weak var rentedProductOwnerLocationLabel: UILabel!
    @IBOutlet weak var rentedProductDesignerLabel: UILabel!
    @IBOutlet weak var rentedProductCancelBookingBtn: UIButton!
    @IBOutlet weak var ratingView: CosmosView!
  
    @IBOutlet weak var forRentProductImage: UIImageView!
    @IBOutlet weak var forRentProductNameLabel: UILabel!
    @IBOutlet weak var forRentProductPriceLabel: UILabel!
    @IBOutlet weak var forRentProductDesignerLabel: UILabel!
    @IBOutlet weak var forRentProductEditItemBtn: UIButton!
    @IBOutlet weak var forRentProductRemoveItemBtn: UIButton!
    @IBOutlet weak var forRentProductCancelBookingBtn: UIButton!
    @IBOutlet weak var forRentProductRatingView: CosmosView!
  
    var delegate : CellActionDelegate?
    
    func setUp(wish : Wish) {
        self.productNameValueLabel.text = wish.name
        self.ownerValueLabel.text = wish.owner
        self.colorValueLabel.text = wish.color
        self.sizeValueLabel.text = wish.size
        self.priceValueLabel.text = "$" + wish.price! + "/day"
        
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
  
    func setUp(rentedProduct : RentedProduct) {
        self.rentedProductNameLabel.text = rentedProduct.name
        ratingView.rating = Double(exactly: (rentedProduct.rating))!
        self.rentedProductPriceLabel.text = "$ " + rentedProduct.price! + "/day"
        self.rentedProductOwnerNameLabel.text = (rentedProduct.userDetail?.firstName)! + " " + (rentedProduct.userDetail?.lastName)!
        self.rentedProductOwnerLocationLabel.text = rentedProduct.userDetail?.location
        self.rentedProductStatusLabel.text = rentedProduct.status
        self.rentedProductDesignerLabel.text = rentedProduct.designer
        if (rentedProduct.cancellationFlag == "TRUE") {
          self.rentedProductCancelBookingBtn.isHidden = false
        } else {
          self.rentedProductCancelBookingBtn.isHidden = true
        }

        if (rentedProduct.picture != nil) {
            let urlwithPercentEscapes =  (rentedProduct.picture!).addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let url:URL = URL(string:urlwithPercentEscapes!)!
            self.rentedProductImage.setImageWith(url, placeholderImage: UIImage(named: "placeholder-test"))
        }
        if (rentedProduct.userDetail?.photo != nil) {
          let urlwithPercentEscapes = (rentedProduct.userDetail?.photo)!.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
              let url:URL = URL(string:urlwithPercentEscapes!)!
              self.rentedProductOwnerImage.contentMode = UIViewContentMode.scaleAspectFill;
              self.rentedProductOwnerImage.setImageWith(url, placeholderImage: UIImage(named: "placeholder-test"))
        }
    }
  
    func setUp(addedProduct : AddedProduct) {
        if (addedProduct.picture != nil) {
          let urlwithPercentEscapes =  (addedProduct.picture).addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let url:URL = URL(string:urlwithPercentEscapes!)!
            self.forRentProductImage.contentMode = UIViewContentMode.scaleAspectFill;
            self.forRentProductImage.setImageWith(url, placeholderImage: UIImage(named: "placeholder-test"))
        }
        self.forRentProductNameLabel.text = addedProduct.name
        self.forRentProductPriceLabel.text = "$" + String(addedProduct.price)
        self.forRentProductDesignerLabel.text = addedProduct.designer
        self.forRentProductRatingView.rating = Double(exactly: (addedProduct.rating))!
    }
    
    
    @IBAction func didTapDelete(_ sender : UIButton) {
        if nil != self.delegate {
            self.delegate?.didRequest(self, .delete)
        }
    }
  
    @IBAction func didTapCancelBooking(_ sender : UIButton) {
        if nil != self.delegate {
            self.delegate?.didRequest(self, .delete)
        }
    }
  
    @IBAction func didTapEditItem(_ sender: UIButton) {
      if nil != self.delegate {
          self.delegate?.didEditItem(self, .delete)
      }
    }

    @IBAction func didTapRemoveItem(_ sender: UIButton) {
      if nil != self.delegate {
          self.delegate?.didRemoveItem(self, .delete)
      }
    }

    @IBAction func didTapBookigList(_ sender: UIButton) {
      if nil != self.delegate {
          self.delegate?.didRemoveItem(self, .delete)
      }
    }

}
