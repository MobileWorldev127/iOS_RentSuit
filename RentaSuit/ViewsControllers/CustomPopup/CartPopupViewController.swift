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

protocol CartPopUpDelegate : AnyObject {
    func moveToRentedView()
}

class CartPopupViewController: UIViewController, WebViewDelegate {
  
  weak var delegate: CartPopUpDelegate?
  
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
  
  func refreshCart() {
    self.dismiss(animated: false, completion: nil)
    self.delegate!.moveToRentedView()
  }
  
  func openWebViewWithUrlString(urlString:String)  {
      let webViewVc:PrivacyViewController = PrivacyViewController.init(nibName: "PrivacyViewController", bundle: nil)
      webViewVc.urlString = urlString
      webViewVc.delegate = self
      self.present(webViewVc, animated: true, completion: nil)
  }
  
  @IBAction func noBtnPressed(_ sender: Any) {
      self.dismiss(animated: false, completion: nil)

  }
  
  @IBAction func pointBtnPressed(_ sender: Any) {
//      showAlertView(title: nil, message: "Total payment= total price + retail price")
    let alert = UIAlertController(title: "Total payment= total price + retail price", message: "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
        switch action.style{
          case .default:
            print("Ok")
          case .cancel:
                print("cancel")

          case .destructive:
                print("destructive")
        }
    }))
    self.present(alert, animated: true, completion: nil)

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
