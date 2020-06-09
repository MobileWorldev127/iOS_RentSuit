//
//  SearchPageViewController.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 11/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
protocol SearchProductDelegate {
    func filterProducts(homeProduct:HomeProduct)
}
class SearchPageViewController: BasepageViewController,PickableValuesTextFieldDelegate {

    @IBOutlet weak var backgroundView: UIView!
    var delegate : SearchProductDelegate?
    var category  :CategoryProduct?
    
    @IBOutlet weak var priceTextField: PickableDataTextField!
    @IBOutlet weak var sizeTextField: PickableDataTextField!
    @IBOutlet weak var searchBtn: UIButton!
    static let sharedInstance: SearchPageViewController = {
        let instance: SearchPageViewController = UIStoryboard(name: "HomeStoryboard", bundle: nil).instantiateViewController(withIdentifier: "SearchPageViewController") as! SearchPageViewController
        instance.index = 1
        
        return instance
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
        setUpInfo()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchPageViewController.didCloseFilter(_:)))
        self.backgroundView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didCloseFilter(_ sender : UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
 
    @IBAction func searchBtnPressed(_ sender: Any) {
        if ( ((priceTextField.text?.isEmpty)! && (sizeTextField.text?.isEmpty)! )){
            self.dismiss(animated: true, completion: nil)
        }else{
            if Reachability.isConnectedToNetwork() {
                filterProductsWs()
            }else {
                self.showAlertView(title: "", message: "network_error".localized)
                
            }
        }
        
    }
    func filterProductsWs()  {
        var params : Dictionary<String , String> = [:]
        if (sizeTextField.text == "XS") {
          params ["size"] = "Extra Small" as String
        }
        if (sizeTextField.text == "S") {
          params ["size"] = "Small" as String
        }
        if (sizeTextField.text == "M") {
          params ["size"] = "Medium" as String
        }
        if (sizeTextField.text == "L") {
          params ["size"] = "Large" as String
        }
        if (sizeTextField.text == "XL") {
          params ["size"] = "Extra Large" as String
        }
        
        if (priceTextField.text == "Per Month") {
          params ["per"] = "per_day" as String
        }
        if (priceTextField.text == "Per Week") {
          params ["per"] = "per_week" as String
        }
        if (priceTextField.text == "Per Month") {
          params ["per"] = "per_month" as String
        }
        params ["page"] = "1" as String
        params ["category_id"] = category?.id as! String
        params ["results_per_page"] = "50" as String
        Product.filtreProduitWs(credentials:  params as! Dictionary<String, String> as Dictionary<String, String>) { (listProducts, error) in
            if (listProducts != nil){
                if self.delegate != nil {
                    self.delegate?.filterProducts(homeProduct: listProducts!)
                }
            }
            self.dismiss(animated: true, completion: nil)

        }
        
    }
    func setUpInfo(){
//        sizeTextField.text = sizeSet.first
//        priceTextField.text = priceSet.first

        setUpSelector(sizeTextField, dataSet: sizeSet, action: .done)
        setUpSelector(priceTextField, dataSet: priceSet, action: .done)

    }
    fileprivate func setUpSelector(_ sender : PickableDataTextField, dataSet : [String]?, action : ExtrasActions) {
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
