//
//  ValidatePayementViewController.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/20/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class ValidatePayementViewController: BaseViewController {

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
            setUpIndicator(method: self.selectedPayementMethod!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStaticInfo()
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
      print("==>")
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
