//
//  ReplyToNotificationViewController.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 12/13/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class ReplyToNotificationViewController: UIViewController {

    @IBOutlet weak var notifcationTitleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func didConfirm(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didDisagree(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
