//
//  BaseViewController.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/15/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var blurEffectView : UIVisualEffectView?
    var isLoading : Bool {
        get {
            return blurEffectView != nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Loader
    
    func startLoading() {
        if !isLoading {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView?.frame = self.view.bounds
            blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            activityIndicator.color = UIColor.yellow
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            activityIndicator.autoresizingMask = [.flexibleRightMargin ,.flexibleLeftMargin ,.flexibleBottomMargin ,.flexibleTopMargin]
            
            blurEffectView?.contentView.addSubview(activityIndicator)
            activityIndicator.center = (blurEffectView?.contentView.center)!
            
            self.view.addSubview(blurEffectView!)
        }
    }
    
    func stopLoading() {
        if isLoading {
            self.blurEffectView?.removeFromSuperview()
            self.blurEffectView = nil
        }
    }
    
    func pushViewControllerOverMain(sbId : String, vcId : String, animated : Bool) {
        let storyboard = UIStoryboard(name: sbId, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: vcId)
        self.navigationController?.pushViewController(vc, animated: animated)
    }
    
    func getViewControllerInstance(sbId : String, vcId : String) -> UIViewController {
        let storyboard = UIStoryboard(name: sbId, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: vcId)
    }
    
    func pushViewController(sbId : String, vcId : String, animated : Bool) {
        let storyboard = UIStoryboard(name: sbId, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: vcId)
        APP_DELEGATE.mainNavigationController?.pushViewController(vc, animated: animated)
    }
    
     func showAlertView(title:String?,message:String?) -> Void {
        let alert = UIAlertController(title: title, message: message , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok_key".localized, style: .default, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func goToItemDetails(_ id : String){
        startLoading()
        Wish.getItemDetails(id) { (detail, code) in
            self.stopLoading()
            if nil != detail {
                let vc = self.getViewControllerInstance(sbId: "ProductDetails",
                                                   vcId: "product_details_screen") as! ProductDetailsViewController
                vc.item = detail
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                
            }
        }
    }

    
}
