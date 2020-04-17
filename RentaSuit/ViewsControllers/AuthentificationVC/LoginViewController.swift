//
//  LoginViewController.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 22/09/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKShareKit

class LoginViewController: BaseAuthetificationViewController {
    
    @IBOutlet weak var cguChekbox: UIButton!
    @IBOutlet weak var cguLabel: UILabel!
    @IBOutlet weak var pswTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let strName = "messagePopup_key".localized
        let string_terms = "Terms_and_Condition_key".localized
        let string_privacy = "Privacy_Polic_key".localized
        
        let attributedString = NSMutableAttributedString(string:strName)
        let rangeTerms = (strName as NSString).range(of: string_terms)
        let rangePrivacy = (strName as NSString).range(of: string_privacy)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.linkBlueApp(), range: rangeTerms)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: rangeTerms)
        
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.linkBlueApp() , range: rangePrivacy)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: rangePrivacy)
        cguLabel.attributedText = attributedString
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel(tap:)))
        self.cguLabel.addGestureRecognizer(tap)
        self.cguLabel.isUserInteractionEnabled = true    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        APP_DELEGATE.mainNavigationController?.popViewController(animated: true)
    }
    @IBAction func cguCheckBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    
    @objc func tapLabel(tap: UITapGestureRecognizer) {
        guard let rangeTerms = self.cguLabel.text?.range(of: "Terms_and_Condition_key".localized)?.nsRange else {
            return
        }
        guard let rangePrivacy = self.cguLabel.text?.range(of: "Privacy_Polic_key".localized)?.nsRange else {
            return
        }
        if tap.didTapAttributedTextInLabel(label: self.cguLabel, inRange: rangeTerms) {
            // Substring tapped
            print("Terms_and_Condition_key")
            openWebViewWithUrlString(urlString: cguUrl)
        }else   if tap.didTapAttributedTextInLabel(label: self.cguLabel, inRange: rangePrivacy)   {
            openWebViewWithUrlString(urlString: privacyUrl)
            print("Privacy_Polic_key")
            
        }
    }
    
    func openWebViewWithUrlString(urlString:String)  {
        let webViewVc:PrivacyViewController = PrivacyViewController.init(nibName: "PrivacyViewController", bundle: nil)
        webViewVc.urlString = urlString
        self.present(webViewVc, animated: true, completion: nil)
        
        
    }
    fileprivate func login() {
        var params : Dictionary<String , AnyObject> = [:]
        params ["email"] = emailTextField.text as AnyObject
        params ["password"] = pswTextField.text as AnyObject
        User.Login(credentials: params as! Dictionary<String, NSObject>, callBack: { loggedUser, err in
            if (loggedUser != nil){
                self.gotHomeViewController()
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
    
    @IBAction func logInBtnPressed(_ sender: Any) {
        if validateInput() {
            if Reachability.isConnectedToNetwork() {
                login()
            }else {
                self.showAlertView(title: "", message: "network_error".localized)

            }
        }
    }
   
    
    
    @IBAction func forgotPswPressed(_ sender: Any) {
        
        APP_DELEGATE.mainNavigationController?.pushViewController(self .getVcFromStoryboardBuVcID(vcId: "ForgotViewController"), animated: true)
    }
    
    @IBAction func twiterBtnPressed(_ sender: Any) {
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("signed in as \(session!.userName)")
                let client = TWTRAPIClient.withCurrentUser()
                
                client.requestEmail { email, error in
                    if (email != nil) {
                        print("signed in as \(session!.userName)");
                    } else {
                        if error != nil {
                            print("error: \(error!.localizedDescription)")
                        }
                        
                    }
                }
            } else {
                if error != nil {
                    print("error: \(error!.localizedDescription)")
                }
            }
        })
    }
    @IBAction func fbBtnPressed(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
//                    self.dict = result as! [String : AnyObject]
                    print(result!)
//                    print(self.dict)
                }
            })
        }
    }
    
    func validateInput() -> Bool {
        let emailString = emailTextField.text
        
        let pswString = pswTextField.text
        
        if emailString!.isEmpty && pswString!.isEmpty{
            self.showAlertView(title:nil, message: "data_incomplete".localized )
            return false
        }else
            if emailString!.isEmpty || emailString!.isBlank  || !emailString!.isValidEmail{
                self.showAlertView(title:nil, message: "email_not_valid".localized )
                return false
            }
            else if pswString!.isEmpty || pswString!.isBlank || pswString!.count < 3 {
                self.showAlertView(title:nil, message: "login_fail".localized )
                
                return false
            }
            else{
                return true
        }
        
    }
    func getVcFromStoryboardBuVcID(vcId:String) -> UIViewController {
        let storyboardAuth = UIStoryboard(name: "AuthentificationStoryboard", bundle: nil)
        let loginVc = storyboardAuth.instantiateViewController(withIdentifier: vcId)
        return loginVc
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
