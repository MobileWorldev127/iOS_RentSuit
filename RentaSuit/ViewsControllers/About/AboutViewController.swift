//
//  AboutViewController.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 23/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class AboutViewController: BasepageViewController {
    
    
    static let sharedInstance: AboutViewController = {
        let instance: AboutViewController = UIStoryboard(name: "HomeStoryboard", bundle: nil).instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        instance.index = 1
        
        return instance
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    fileprivate func openAppBy(_ appURL: URL, _ safariURL: URL) {
        if UIApplication.shared.canOpenURL(appURL as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL as URL)
            }
        } else {
            //redirect to safari because the user doesn't have Instagram
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(safariURL as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(safariURL as URL)
            }
        }
    }
    
    @IBAction func instagram(_ sender: Any) {
        let appURL = URL(string: "instagram://user?username=\(RENT_SOCIAL_URL)")!
        let safariURL =   URL(string: "https://instagram.com/\(RENT_SOCIAL_URL)")!
        openAppBy(appURL, safariURL)
    }
    @IBAction func pinterestBtn(_ sender: Any) {
        let appURL = URL(string: "pinterest://\(RENT_SOCIAL_URL)")!
        let safariURL =   URL(string: "https://www.pinterest.com/\(RENT_SOCIAL_URL)")!
        openAppBy(appURL, safariURL)
    }
    @IBAction func fbBtnPressed(_ sender: Any) {
        let appURL = URL(string: "fb://profile/\(RENT_SOCIAL_URL)")!
        let safariURL =   URL(string: "https://www.facebook.com/\(RENT_SOCIAL_URL)")!
        openAppBy(appURL, safariURL)
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
