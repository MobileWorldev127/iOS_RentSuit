//
//  ForgotViewController.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 29/09/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class ForgotViewController: BaseAuthetificationViewController {

    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    fileprivate func forgot() {
        var params : Dictionary<String , AnyObject> = [:]
        params ["email"] = emailTextField.text as AnyObject
        
        User.ForgotPsw(credentials: params as! Dictionary<String, NSObject>, callBack: { succes, err in
            if (succes == "succes"){
                APP_DELEGATE.mainNavigationController?.popViewController(animated: true)
            }else{
                if err != nil{
                    let error:NSError = err! as NSError ;
                    if error.userInfo.count != 0 {
                        self.showAlertMessageByError(errorDict: error.userInfo)
                    }else{
                        if  error.domain.isEmpty{
                            self.showAlertView(title: "", message: "server_error".localized)
                            
                        }else{
                            self.showAlertView(title: "", message: error.domain)
                            
                        }
                    }
                }else{
                    self.showAlertView(title: "", message: "server_error".localized)
                }
            }
        })
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        if validateInput() {
            if Reachability.isConnectedToNetwork(){
                forgot()
            }else{
                self.showAlertView(title: "", message: "network_error".localized)

            }
        }
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        APP_DELEGATE.mainNavigationController?.popViewController(animated: true)
    }
    func validateInput() -> Bool {
        let emailString = emailTextField.text
        
        if emailString!.isEmpty{
            self.showAlertView(title:nil, message: "data_incomplete".localized )
            return false
        }else
            if emailString!.isEmpty || emailString!.isBlank  || !emailString!.isValidEmail{
                self.showAlertView(title:nil, message: "email_not_valid".localized )
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
