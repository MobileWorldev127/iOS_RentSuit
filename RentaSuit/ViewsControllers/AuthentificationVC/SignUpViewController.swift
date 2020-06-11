//
//  SignUpViewController.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 22/09/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKShareKit
class SignUpViewController: BaseAuthetificationViewController {
    
    @IBOutlet weak var confirmPswtTetxfield: UITextField!
    @IBOutlet weak var pswTextField: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var firstNameTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func register() {
        var params : Dictionary<String , AnyObject> = [:]
        params["first_name"] = firstNameTextfield.text as AnyObject
        params ["last_name"] = lastNameTextfield.text as AnyObject
        params ["email"] = emailTextfield.text as AnyObject
        params ["password"] = pswTextField.text as AnyObject
        
        User.register(credentials: params as! Dictionary<String, NSObject>, callBack: { loggedUser, err in
          print(loggedUser)
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
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        if validateInput() {
            if Reachability.isConnectedToNetwork() {
                register()
            }else{
                self.showAlertView(title: "", message: "network_error".localized)
            }
        }
        
    }
   
    
    
    @IBAction func logInBtnPressed(_ sender: Any) {
        APP_DELEGATE.mainNavigationController?.pushViewController(self .getVcFromStoryboardBuVcID(vcId: "LoginViewController"), animated: true)
    }
    @IBAction func twitterBtnPressed(_ sender: Any) {
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("signed in as \(session!.userID)")
               self.sendSocialWs(id: session!.userID)
//                let client = TWTRAPIClient.withCurrentUser()
//                
//                client.requestEmail { email, error in
//                    if (email != nil) {
//                        print("signed in as \(session!.userName)");
//                    } else {
//                        if error != nil {
//                            print("error: \(error!.localizedDescription)")
//                        }
//                        
//                    }
//                }
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
//                     = result as! [String : AnyObject]
                    if (result != nil ){
                        if (result is [String : AnyObject] ) {
                            let resultDict : [String : AnyObject] = result as! [String : AnyObject]
                            let userFbId : AnyObject = resultDict["id"]!
                            print(result!)
                            self.sendSocialWs(id: userFbId as! String)
                        }
                    }
                    
                }
            })
        }
    }
    func sendSocialWs(id:String) {
        
        var params : Dictionary<String , AnyObject> = [:]
        params ["email"] = id as AnyObject
        User.signInWithSocial(credentials: params as! Dictionary<String, NSObject>, callBack: { loggedUser, err in
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
    func getVcFromStoryboardBuVcID(vcId:String) -> UIViewController {
        let storyboardAuth = UIStoryboard(name: "AuthentificationStoryboard", bundle: nil)
        let loginVc = storyboardAuth.instantiateViewController(withIdentifier: vcId)
        return loginVc
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        APP_DELEGATE.mainNavigationController?.popViewController(animated: true)
    }
    func validateInput() -> Bool {
        let emailString = emailTextfield.text
        let lastname = lastNameTextfield.text
        let firstName = firstNameTextfield.text
        let pswString = pswTextField.text
        let confirmPsw = confirmPswtTetxfield.text
        
        if emailString!.isEmpty && lastname!.isEmpty && firstName!.isEmpty && pswString!.isEmpty && confirmPsw!.isEmpty{
            self.showAlertView(title:nil, message: "data_incomplete".localized )
            return false
        }else
            if emailString!.isEmpty || emailString!.isBlank  || !emailString!.isValidEmail{
                self.showAlertView(title:nil, message: "email_not_valid".localized )
                return false
            }
            else if lastname!.isEmpty || lastname!.isBlank  {
                self.showAlertView(title:nil, message: "login_fail".localized )
                
                return false
                
            }else if firstName!.isEmpty || firstName!.isBlank{
                self.showAlertView(title:nil, message: "login_fail".localized )
                
                return false
            }else if pswString!.isEmpty || pswString!.isBlank || pswString!.count < 3 {
                self.showAlertView(title:nil, message: "login_fail".localized )
                
                return false
            }else if  confirmPsw!.isEmpty || confirmPsw!.isBlank || confirmPsw!.count < 3  {
                self.showAlertView(title:nil, message: "login_fail".localized )
                
                return false
            }else if confirmPsw! != pswString  {
                self.showAlertView(title:nil, message: "login_fail".localized )
                
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
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
