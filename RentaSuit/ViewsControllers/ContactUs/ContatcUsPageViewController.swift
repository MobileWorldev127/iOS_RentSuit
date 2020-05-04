//
//  ContatcUsPageViewController.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 11/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class ContatcUsPageViewController: BasepageViewController,PickableValuesTextFieldDelegate  {
    
    @IBOutlet weak var messageTextView: UITextView!
    
    
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var categorytextField: PickableDataTextField!
    @IBOutlet weak var phoneLabel: UILabel!
    
    static let sharedInstance: ContatcUsPageViewController = {
        let instance: ContatcUsPageViewController = UIStoryboard(name:"HomeStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ContatcUsPageViewController") as! ContatcUsPageViewController
        instance.index = 2
        
        return instance
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailLabel.text = RENT_APP_EMAIL
        self.phoneLabel.text = RENT_APP_PHONE
        setUpInfo()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    fileprivate func setUpSelector(_ sender : PickableDataTextField, dataSet : [String]?, action : ExtrasActions) {
        sender.dataSet = (dataSet! as [AnyObject])
        sender.extras = action
        sender.pickableDelegate = self
    }
    
     func setUpInfo(){
        setUpSelector(categorytextField, dataSet: categorySet, action: .done)
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

    @IBAction func sendBtnPressed(_ sender: Any) {
        
        if validateInput() {
            if Reachability.isConnectedToNetwork() {
                sendContactUs()
            }else {
                self.showAlertView(title: "", message: "network_error".localized)
                
            }
        }
    }
    func sendContactUs()  {
        var params : Dictionary<String , AnyObject> = [:]
        params ["name"] = nameTextfield.text as AnyObject
        params ["email_address"] = emailTextField.text as AnyObject
        params ["message"] = messageTextView.text as AnyObject
        params ["subject"] = categorytextField.text as AnyObject
        params ["localization"] = "localization" as AnyObject
        News.contactUsWs(credentials: params as! Dictionary<String, NSObject>) { (succes, error) in
            if (succes == true){
                self.showAlertView(title: "good_job_key".localized, message: "contact_us_succes_key".localized)
            }
        }

    }
    @IBAction func emailBtnPressed(_ sender: Any) {
        
    }
    func validateInput() -> Bool {
        let emailString = emailTextField.text
        
        let nameString = nameTextfield.text
        
        let messageString = messageTextView.text
        let categoryString = categorytextField.text

        if emailString!.isEmpty && nameString!.isEmpty && messageString!.isEmpty{
            self.showAlertView(title:nil, message: "data_incomplete".localized )
            return false
        }else
            if emailString!.isEmpty || emailString!.isBlank  || !emailString!.isValidEmail{
                self.showAlertView(title:nil, message: "email_not_valid".localized )
                return false
            }
            else if nameString!.isEmpty || emailString!.isEmpty  || messageString!.isEmpty   {
                self.showAlertView(title:nil, message: "data_incomplete".localized )
                return false
            }
            else if categoryString!.isEmpty || categoryString! == "Plz_category_key".localized  {
                self.showAlertView(title:nil, message: "Plz_category_key".localized)
                return false
            }
           
            else{
                return true
        }
        
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
