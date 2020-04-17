//
//  ChoiceViewController.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 18/09/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class ChoiceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBAction func signUpBtnPressed(_ sender: Any) {
        APP_DELEGATE.mainNavigationController?.pushViewController(self .getVcFromStoryboardBuVcID(vcId: "SignUpViewController"), animated: true)
    }
    
    func getVcFromStoryboardBuVcID(vcId:String) -> UIViewController {
        let storyboardAuth = UIStoryboard(name: "AuthentificationStoryboard", bundle: nil)
        let loginVc = storyboardAuth.instantiateViewController(withIdentifier: vcId)
        return loginVc
    }
    @IBAction func logInBtnPressed(_ sender: Any) {
        APP_DELEGATE.mainNavigationController?.pushViewController(self .getVcFromStoryboardBuVcID(vcId: "LoginViewController"), animated: true)
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
