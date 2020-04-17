//
//  SplashViewController.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 18/09/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(splashTimeOut), userInfo: nil, repeats: false)
        // Do any additional setup after loading the view.
    }
    @objc func splashTimeOut(sender : Timer){
        
        if User.isConnected() {
            self.gotHomeViewController()
        }else{
            self.gotChoiceViewController()
        }
    }
    
    func gotChoiceViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChoiceViewController")
        APP_DELEGATE.mainNavigationController?.pushViewController(vc, animated: true)
    }
    func gotHomeViewController() {
        let storyboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        APP_DELEGATE.mainNavigationController?.pushViewController(vc, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
