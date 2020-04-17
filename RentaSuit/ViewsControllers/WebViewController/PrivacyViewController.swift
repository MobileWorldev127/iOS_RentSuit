//
//  PrivacyViewController.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 22/11/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import WebKit
class PrivacyViewController: UIViewController ,UIWebViewDelegate{
    @IBOutlet weak var webViewContainer: UIView!
    var urlString : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        }
                let webView = UIWebView(frame:  CGRect(x: 0, y: 0, width: webViewContainer.frame.size.width, height: webViewContainer.frame.size.height))
               webViewContainer.addSubview(webView)
               webView.delegate = self
                let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DispatchQueue.main.async {
            LoadingOverlay.shared.hideOverlayView()
        }
    }
    @IBAction func closeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        DispatchQueue.main.async {
            LoadingOverlay.shared.hideOverlayView()
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
