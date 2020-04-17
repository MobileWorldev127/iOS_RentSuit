//
//  BaseAuthetificationViewController.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 01/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class BaseAuthetificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  public func showAlertView(title:String?,message:String?) -> Void {
        let alert = UIAlertController(title: title, message: message , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok_key".localized, style: .default, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
 public func showAlertMessageByError(errorDict:[String : Any])  {
        let dictNSMutable = NSMutableDictionary(dictionary: errorDict)
        
        let values:NSArray = dictNSMutable.allValues as NSArray ;
        if (values.count != 0){
            let val = values.object(at: 0)
            if val is String{
                self.showAlertView(title: "", message: val as? String)
            }else if val is NSArray{
                let arrayOfMsg: NSArray  = val as! NSArray
                if arrayOfMsg.count != 0{
                    let message = arrayOfMsg.firstObject;
                    if message is String{
                        self.showAlertView(title: "", message: message as? String)
                        
                    }else{
                        self.showAlertView(title: "", message: "server_error".localized)
                    }
                    
                }else{
                    self.showAlertView(title: "", message: "server_error".localized)
                }
            }else{
                self.showAlertView(title: "", message: "server_error".localized)
                
            }
        }
        
    }
    
    func gotHomeViewController() {
        let storyboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        APP_DELEGATE.mainNavigationController?.pushViewController(vc, animated: true)
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
