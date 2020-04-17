//
//  RentRequestViewController.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 12/13/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class RentRequestViewController: UIViewController {

    @IBOutlet weak var productImage: UIImageView!
    let url = URL(string: "https://www.lilyboutique.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/1/4/142_127_.jpg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productImage.setImageWith(self.url!)
        // Do any additional setup after loading the view.
    }


    @IBAction func didAccept(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didDecline(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
