//
//  MeasurementBoardViewController.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 12/12/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class MeasurementBoardViewController: UIViewController {

    @IBOutlet weak var measurementImage: WebImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.measurementImage.setImageFromUrl("https://www.rentasuit.ca/user-interface/img/size_chart.png", placeHolder: nil)
    }

    @IBAction func didTapClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
