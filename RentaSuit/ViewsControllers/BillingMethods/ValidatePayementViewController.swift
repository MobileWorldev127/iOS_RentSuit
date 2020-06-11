//
//  ValidatePayementViewController.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/20/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import Braintree

class ValidatePayementViewController: BaseViewController {

    var braintreeClient: BTAPIClient!
  
    @IBOutlet weak var payementMethodLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
    @IBOutlet weak var transactionAmountInput: UITextField!
    @IBOutlet weak var billingInfoLabel: UILabel!
    @IBOutlet weak var validatePayementButton: UIButton!
    @IBOutlet weak var animationConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorView: UIView!
    
    @IBOutlet weak var payementMethodView: UIView!
    
    var didAppearOnce : Bool = false
    
    var selectedPayementMethod : PayementMethod?
    
    override func viewWillAppear(_ animated: Bool) {
        if !didAppearOnce {
            didAppearOnce = true
//            setUpIndicator(method: self.selectedPayementMethod!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStaticInfo()
        braintreeClient = BTAPIClient(authorization: "sandbox_csdtvgwj_5snrzj39bv5gmh4k")!
        
    }
    
    func setUpStaticInfo(){

    }
    
    fileprivate func setUpIndicator(method : PayementMethod){
        switch  method{
        case .paypal:
            animateToPos(position : 0)
            break
        case .creditCard:
            animateToPos(position : 1)
            break
        case .bankTransfer:
            animateToPos(position : 2)
            break
        }
    }
    
    fileprivate func animateToPos(position : Int) {
        var newValue = CGFloat(0)
        newValue = (self.payementMethodView.frame.width / CGFloat(3)) * CGFloat(position)
        self.animationConstraint.constant = newValue
    }
    
    @IBAction func didTapValidatePayement(_ sender: Any) {
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self
      
        // Specify the transaction amount here. "2.32" is used in this example.
      let request = BTPayPalRequest(amount: transactionAmountInput.text as! String)
        request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options

        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")

                // Access additional information
                let email = tokenizedPayPalAccount.email
                let firstName = tokenizedPayPalAccount.firstName
                let lastName = tokenizedPayPalAccount.lastName
                let phone = tokenizedPayPalAccount.phone

                // See BTPostalAddress.h for details
                let billingAddress = tokenizedPayPalAccount.billingAddress
                let shippingAddress = tokenizedPayPalAccount.shippingAddress
              self.billingInfoLabel.text = "The total amount to be padin is $" + self.transactionAmountInput.text! + " and some charges may icure"
            } else if let error = error {
                // Handle error here...
            } else {
                // Buyer canceled payment approval
            }
        }
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ValidatePayementViewController: BTViewControllerPresentingDelegate{
  func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
    
  }
  
  func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
    
  }
  
  
}

extension ValidatePayementViewController: BTAppSwitchDelegate {
  func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
    
  }
  
  func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
    
  }
  
  func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
    
  }
  
  
}
