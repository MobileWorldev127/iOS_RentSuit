//
//  BilingsMethodsViewController.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/20/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

enum PayementMethod {
    case paypal
    case creditCard
    case bankTransfer
}

class BilingsMethodsViewController: BaseViewController {

    @IBOutlet weak var selectMethodLabel: UILabel!
    
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cardTypeLabel: UILabel!
    @IBOutlet weak var cvvNumberLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cardTypeTextField: UITextField!
    @IBOutlet weak var cvvNumberTextField: UITextField!
   
    
    @IBOutlet weak var paypalButtton: UIButton!
    @IBOutlet weak var creditCardButton: UIButton!
    @IBOutlet weak var bankTransferButton: UIButton!
    
    var selectedPayementMethod : PayementMethod?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStaticInfo()
    }
    
    func setUpStaticInfo(){

    }
    
    @IBAction func didSelectMethod(_ sender: UIButton) {
        if sender == paypalButtton {
            self.selectedPayementMethod = .paypal
        }
        
        if sender == creditCardButton {
            self.selectedPayementMethod = .creditCard
        }
        
        if sender == bankTransferButton {
            self.selectedPayementMethod = .bankTransfer
        }
    }
    
    @IBAction func didTapPayButton(_ sender: Any) {
        if nil != selectedPayementMethod {
            let vc = getViewControllerInstance(sbId: "BillingMethods",
                               vcId: "validate_payement_screen") as! ValidatePayementViewController
            vc.selectedPayementMethod = self.selectedPayementMethod
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            showAlertView(title: nil, message: "alert_select_payement".localized)
        }
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
