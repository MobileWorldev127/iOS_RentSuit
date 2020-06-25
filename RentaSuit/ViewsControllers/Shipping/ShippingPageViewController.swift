//
//  ShippingPageViewController.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 11/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class ShippingPageViewController: BasepageViewController,PickableValuesTextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
   
    
    
    @IBOutlet weak var shippingTextField: PickableDataTextField!
    
 
//    @IBOutlet weak var cityFromTextField: PickableDataTextField!
    
//    @IBOutlet weak var cityDestTextFiled: PickableDataTextField!
  

    
    @IBOutlet weak var stateFromTextFiled: PickableDataTextField!
    @IBOutlet weak var stateDestCityTextField: PickableDataTextField!
    @IBOutlet weak var adressFromTextField: UITextField!
    
    @IBOutlet weak var adressDesttextField: UITextField!
    @IBOutlet weak var zipCodeFromTextFiled: UITextField!
    @IBOutlet weak var zipCodeDesttextField: UITextField!
    
    @IBOutlet weak var widhttextField: UITextField!
    @IBOutlet weak var lenghtTextField: UITextField!
    
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextfiled: UITextField!
    @IBOutlet weak var cityFromTextField: UITextField!
    
    
    @IBOutlet weak var cityDestTextField: UITextField!
    
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var shippingResultTableView: UITableView!
    
    let shippingCellId = "shippingCellId"
    let shippingCellHeight:CGFloat = 60
    var shippingArray :[Shipping] = [Shipping]()

    override func viewDidLoad() {
        super.viewDidLoad()
        shippingTextField.pickableDelegate = self;
        stateFromTextFiled.pickableDelegate = self;
        stateDestCityTextField.pickableDelegate = self;
        setUpInfo()
        self.shippingResultTableView.delegate = self
        self.shippingResultTableView.dataSource  = self
        
        shippingResultTableView.register(UINib(nibName: "ShippingCellTableView", bundle: nil), forCellReuseIdentifier: shippingCellId)

        // Do any additional setup after loading the view.
        
    }
    fileprivate func setUpSelector(_ sender : PickableDataTextField, dataSet : [String]?, action : ExtrasActions) {
        sender.dataSet = (dataSet! as [AnyObject])
        sender.extras = action
        sender.pickableDelegate = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        self.heightTableViewConstraint.constant  = CGFloat((shippingArray.count * Int(shippingCellHeight)) + 50)
       return shippingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: shippingCellId, for: indexPath) as! ShippingCellTableView
        cell.backgroundColor = indexPath.row % 2 == 0 ? .white : .lightGray
        let shipping : Shipping = shippingArray[indexPath.row]
        cell.setupCellWith(shipping: shipping)
        return cell

    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        let footerlabel:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width:320 , height: 500))
        footerlabel.text = "note_shipping_key".localized
        footerlabel.textColor = UIColor.lightGray
        footerlabel.numberOfLines = 0;
        footerlabel.sizeToFit()
        footerlabel.center = footerView.center
        footerView.addSubview(footerlabel)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    func setUpInfo(){
        stateFromTextFiled.text = citySet.first
        stateDestCityTextField.text = citySet.first
        
        setUpSelector(shippingTextField, dataSet: paysCity, action: .done)
        setUpSelector(stateFromTextFiled, dataSet: citySet, action: .done)
        setUpSelector(stateDestCityTextField,  dataSet: citySet , action: .done)

    }
    static let sharedInstance: ShippingPageViewController = {
        let instance: ShippingPageViewController = UIStoryboard(name: "HomeStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ShippingPageViewController") as! ShippingPageViewController
        instance.index = 3
        
        return instance
    }()
    
    
    @IBAction func continueShoppingBtnPressed(_ sender: Any) {
//        if validateInput() {
            if Reachability.isConnectedToNetwork() {
                postShipping()
            }else {
                self.showAlertView(title: "", message: "network_error".localized)
                
            }
//        }
    }
    
    func postShipping()  {
        let shippingString = shippingTextField.text
        let cityFromString = cityFromTextField.text
        let cityDestString = cityDestTextField.text
        let adressFromString = adressFromTextField.text
        let adressDestString = adressDesttextField.text
        let zipCodeFromString = zipCodeFromTextFiled.text
        let zipCodeDestString = zipCodeDesttextField.text
        let widhtString = widhttextField.text
        let lenghtString = lenghtTextField.text
        let weightString = weightTextField.text
        let heightString = heightTextfiled.text
        
        let stateCityFromString = stateFromTextFiled.text
        let stateCityDestString = stateDestCityTextField.text
        var params : Dictionary<String , AnyObject> = [:]
//        params ["type"] = shippingString as AnyObject
//        params ["destination_address"] = adressDestString as AnyObject
//        params ["destination_city"]  = cityDestString as AnyObject
//        params ["destination_state_province_code"]  = stateCityDestString as AnyObject
//        params ["destination_countries"]  = cityDestString as AnyObject
//        params ["destination_zipcode"]  = zipCodeDestString as AnyObject
//
//        params ["from_address"]  = adressFromString as AnyObject
//        params ["from_city"]  = cityFromString as AnyObject
//        params ["from_state_province_code"]  = stateCityFromString as AnyObject
//
//        params ["from_countries"]  = cityDestString as AnyObject
//        params ["from_zipcode"]  = zipCodeFromString as AnyObject
//        params ["length"]  = lenghtString as AnyObject
//        params ["width"]  = widhtString as AnyObject
//        params ["height"]  = heightString as AnyObject
//        params ["weight"]  = weightString as AnyObject
//
        
        //for test
        params ["type"] = "Localization".toObject
        params ["destination_address"] = "2811thavenue".toObject
        params ["destination_city"]  = "AlbertaCA".toObject
        params ["destination_state_province_code"]  = "canada".toObject
        params ["destination_countries"]  = "Canada".toObject
        params ["destination_zipcode"]  = "M3C 0C3".toObject
        
        params ["from_address"]  = "678sheppard Ave".toObject
        params ["from_city"]  = "Ontario.CA".toObject
        params ["from_state_province_code"]  = "canada".toObject
        
        params ["from_countries"]  = "Canada".toObject
        params ["from_zipcode"]  = "M3C 0C3".toObject
        params ["length"]  = "15".toObject
        params ["width"]  = "15".toObject
        params ["height"]  = "15".toObject
        params ["weight"]  = "15".toObject
        


        Shipping.getShippingCalculator(credentials: params as! Dictionary<String, NSObject>) { (shippingArrayResult, error) in
            if shippingArrayResult?.count != 0 {
                self.shippingArray = shippingArrayResult!
                self.shippingResultTableView .reloadData()
            }else{
                self.showAlertView(title: nil, message: "server_error".localized)
            }
        }


    }
    func validateInput() -> Bool {
        let shippingString = shippingTextField.text
        
        let cityFromString = cityFromTextField.text
        let cityDestString = cityDestTextField.text
        let adressFromString = adressFromTextField.text
        let adressDestString = adressDesttextField.text
        let zipCodeFromString = zipCodeFromTextFiled.text
        let zipCodeDestString = zipCodeDesttextField.text
        let widhtString = widhttextField.text
        let lenghtString = lenghtTextField.text
        
        let weightString = weightTextField.text
        let heightString = heightTextfiled.text
        
        let stateCityFromString = stateFromTextFiled.text
        let stateCityDestString = stateDestCityTextField.text

        if (shippingString!.isEmpty ||
        cityFromString!.isEmpty ||
        cityDestString!.isEmpty ||
        adressFromString!.isEmpty ||
        adressDestString!.isEmpty ||
        zipCodeFromString!.isEmpty ||
        zipCodeDestString!.isEmpty ||
        widhtString!.isEmpty ||
        lenghtString!.isEmpty ||
        weightString!.isEmpty ||
        heightString!.isEmpty ||
        stateCityDestString!.isEmpty ||
        stateCityFromString!.isEmpty )
        {
            self.showAlertView(title:nil, message: "data_incomplete".localized )
            return false
        }else{
           return true
        }
        
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
