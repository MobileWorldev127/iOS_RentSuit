//
//  CustomPopupViewController.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 19/11/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import WebKit
class CustomPopupViewController: UIViewController {

    @IBOutlet weak var checkBoxbtn: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
 
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
        messageLabel.attributedText = attributedString
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel(tap:)))
        self.messageLabel.addGestureRecognizer(tap)
        self.messageLabel.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }

    @IBAction func checboxBtnActionPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    
    @objc func tapLabel(tap: UITapGestureRecognizer) {
        guard let rangeTerms = self.messageLabel.text?.range(of: "Terms_and_Condition_key".localized)?.nsRange else {
            return
        }
        guard let rangePrivacy = self.messageLabel.text?.range(of: "Privacy_Polic_key".localized)?.nsRange else {
            return
        }
        if tap.didTapAttributedTextInLabel(label: self.messageLabel, inRange: rangeTerms) {
            // Substring tapped
            print("Terms_and_Condition_key")
            openWebViewWithUrlString(urlString: cguUrl)
        }else   if tap.didTapAttributedTextInLabel(label: self.messageLabel, inRange: rangePrivacy)   {
            openWebViewWithUrlString(urlString: privacyUrl)
            print("Privacy_Polic_key")

        }
    }
    
    func openWebViewWithUrlString(urlString:String)  {
        let webViewVc:PrivacyViewController = PrivacyViewController.init(nibName: "PrivacyViewController", bundle: nil)
        webViewVc.urlString = urlString
        self.present(webViewVc, animated: true, completion: nil)
    }
  
    @IBAction func noBtnPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        
    }
  
    @IBAction func acceptBtnPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

}
