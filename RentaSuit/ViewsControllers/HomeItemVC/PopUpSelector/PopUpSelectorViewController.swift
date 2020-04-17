//
//  PopUpSelectorViewController.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/29/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

protocol PopUpSelectorDelegate {
    func didTapAtIndex(index : Int)
}

class PopUpSelectorViewController: UIViewController {

    @IBOutlet var menuItems: [UIButton]!
    var delegate : PopUpSelectorDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PopUpSelectorViewController.didRequestCloseMenu(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func didRequestCloseMenu(_ sender : UITapGestureRecognizer) {
        self.remove()
    }
    @IBAction func didTapMenuItem(_ sender: UIButton) {
        guard let index = menuItems.firstIndex(of: sender) else { return }
        
        switch index {
        case 0...7:
            if nil != delegate{
                delegate?.didTapAtIndex(index: index)
            }
            self.remove()
            break
        default:
            self.remove()
            break
        }
        
    }
}
