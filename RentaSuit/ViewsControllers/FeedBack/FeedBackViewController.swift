//
//  FeedBackViewController.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 11/22/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import Cosmos

class FeedBackViewController: BaseViewController {

    @IBOutlet weak var reviewText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didRequestClosePopUp(_ sender : Any) {
        self.remove()
    }
 
    @IBAction func didTapSubmitt(_ sender: Any) {
    }
}
