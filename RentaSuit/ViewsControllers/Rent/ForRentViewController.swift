//
//  ForRentViewController.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 11/9/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class ForRentViewController: BaseViewController, PickableValuesTextFieldDelegate {

    @IBOutlet weak var deliveryOptionInput: PickableDataTextField!
    @IBOutlet weak var rentStartDateInput: PickableDateTextField!
    @IBOutlet weak var rentEndDateInput: PickableDateTextField!
    @IBOutlet weak var rentAdressInput: UITextField!
    @IBOutlet weak var rentStreetInput: UITextField!
    @IBOutlet weak var rentApartNumberInput: UITextField!
    @IBOutlet weak var rentCityInput: UITextField!
    @IBOutlet weak var rentStateInput: UITextField!
    @IBOutlet weak var rentZipCodeInput: UITextField!
    @IBOutlet weak var rentCountryInput: UITextField!
    @IBOutlet weak var rentContactInput: UITextField!
    @IBOutlet weak var rentEmailnput: UITextField!
    @IBOutlet weak var rentDescriptionInput: UITextField!
    @IBOutlet weak var productImage: WebImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var designerName: UILabel!
    
    var product : Wish?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInfo()
        self.rentStartDateInput.pickableDelegate = self
        self.rentStartDateInput.extras = .done
        self.rentEndDateInput.pickableDelegate = self
        self.rentEndDateInput.extras = .done
    }

    func setUpInfo(){
        self.productName.text = self.product?.name
        self.designerName.text = self.product?.designer
        if product?.picture != nil {
            let urlwithPercentEscapes =  (product?.picture)!.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string:urlwithPercentEscapes!)!
            self.productImage.setImageWith(url, placeholderImage: UIImage(named: "placeholder-test"))
        }
        setUpSelector(deliveryOptionInput, dataSet: deliveryOptionSet, action: .both)
    }
    fileprivate func setUpSelector(_ sender : PickableDataTextField, dataSet : [String]?, action : ExtrasActions) {
        sender.text = dataSet?.first
        sender.dataSet = (dataSet! as [AnyObject])
        sender.extras = action
        sender.pickableDelegate = self
    }
    func didSelectValue(sender: PickableValuesTextField, value: AnyObject?) {
        if value is String {
            sender.text = (value as! String)
        }
    }
    
    func didRequestNext(sender: PickableValuesTextField) {
        
    }
    
    func didRequestDone(sender: PickableValuesTextField) {
        self.view.endEditing(true)
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func didTapContinue(_ sender: Any) {
        var params = [String : NSObject]()
        if String.isValid(product?.id) {
            params["product_id"] = (product?.id)!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        if String.isValid(deliveryOptionInput.text) {
            if (deliveryOptionInput.text == "Pick up from UPS") {
              params["delivery_option"] = "Ups".toObject
            }
            else {
              params["delivery_option"] = deliveryOptionInput.text!.toObject
            }
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(product?.id) {
            params["product_id"] = product?.id!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(rentStartDateInput.text) {
            params["rental_start_date"] = rentStartDateInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(rentEndDateInput.text) {
            params["rental_end_date"] = rentEndDateInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(rentStreetInput.text) {
            params["street_number"] = rentStreetInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(rentAdressInput.text) {
            params["address"] = rentAdressInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(rentCityInput.text) {
            params["city"] = rentCityInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(rentStateInput.text) {
            params["state"] = rentStateInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        
        if String.isValid(rentZipCodeInput.text) {
            params["postal_code"] = rentZipCodeInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(rentCountryInput.text) {
            params["country"] = rentCountryInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(rentContactInput.text) {
            params["contact_number"] = rentContactInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(rentEmailnput.text) {
            params["email"] = rentEmailnput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(rentDescriptionInput.text) {
            params["description"] = rentDescriptionInput.text!.toObject
        }
        
        
        self.startLoading()
        Cart.add(params: params) { (msg) in
            Cart.cartList(callBack:{ (products, code) in
              self.stopLoading()
              let vc  = self.getViewControllerInstance(sbId: "Cartlist",vcId: "cart_list_scene") as! CartListViewController
              vc.cartList = products
//              let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
//              self.navigationController?.popToViewController(viewControllers[viewControllers.count - 4], animated: false)
              self.navigationController?.pushViewController(vc, animated: true)
            })
        }
      
    }
}
