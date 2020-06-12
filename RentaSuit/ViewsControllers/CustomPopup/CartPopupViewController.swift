//
//  CartPopupViewController.swift
//  RentaSuit
//
//  Created by macos on 6/10/20.
//  Copyright © 2020 MacBook Pro. All rights reserved.
//

import Foundation

import WebKit
import Braintree

class CartPopupViewController: UIViewController {
  
  @IBOutlet weak var rentValueLabel: UILabel!
  @IBOutlet weak var shippingLabel: UILabel!
  @IBOutlet weak var feeLabel: UILabel!
  @IBOutlet weak var totalChargesLabel: UILabel!
  @IBOutlet weak var totalPaymentLabel: UILabel!
  
  var braintreeClient: BTAPIClient!
  
  var cartList : [Cart]?
  var retailPriceList: [Int]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    braintreeClient = BTAPIClient(authorization: "sandbox_csdtvgwj_5snrzj39bv5gmh4k")!
    
    for element in self.cartList! {
      print(element.deliveryOption)
      var rentValue = 0;
      var shippingValue = 0;
      var totalChargesValue = 0;
      var totalPaymentValue = 0;
      var totalRetailPriceValue = 0;
      for (index, item) in self.cartList!.enumerated() {
          rentValue += Int(item.total)
          if (item.shippingInfo == nil){
            shippingValue += 0;
          } else {
            shippingValue += (item.shippingInfo?.hashValue)!
          }
          totalChargesValue += rentValue + shippingValue + rentValue/10;
          totalRetailPriceValue += self.retailPriceList![index];
          totalPaymentValue += totalChargesValue + totalRetailPriceValue
        
      }
      self.rentValueLabel.text = "$ " + String(rentValue);
      self.shippingLabel.text = "$ " + String(shippingValue);
      self.feeLabel.text = "$ " + String(rentValue/10);
      self.totalChargesLabel.text = "$ " + String(totalChargesValue);
      self.totalPaymentLabel.text = "$ " + String(totalPaymentValue);
      
    }   
    
  }
  
  func openWebViewWithUrlString(urlString:String)  {
      let webViewVc:PrivacyViewController = PrivacyViewController.init(nibName: "PrivacyViewController", bundle: nil)
      webViewVc.urlString = urlString
      self.present(webViewVc, animated: true, completion: nil)
  }
  
  @IBAction func noBtnPressed(_ sender: Any) {
      self.dismiss(animated: false, completion: nil)

  }
  @IBAction func orderBtnPressed(_ sender: Any) {
      Checkout.generatePaymentURL { (products, code) in
        print((products?.paymentKey)!)
        print((products?.paymentUrl)!)

        var params = [String : NSObject]()
        params["payment_key"] = (products?.paymentKey)!.toObject
        
//        PaymentStatus.paymentStatus(params: params){ (Data) in
//          print("=>", Data)
//        }
        
        self.openWebViewWithUrlString(urlString: (products?.paymentUrl)!)
        print("Privacy_Polic_key")
      }
//      self.dismiss(animated: false, completion: nil)
  }
}
