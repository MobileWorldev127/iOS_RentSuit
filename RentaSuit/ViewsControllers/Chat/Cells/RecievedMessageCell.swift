//
//  RecievedMessageCell.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/16/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class RecievedMessageCell: UITableViewCell, MessageCellProtocol {
    
    @IBOutlet weak var messageLabel: UILabel!
    func setUpMessageContent(_ message: String) {
        self.messageLabel.text = message
    }

    override func prepareForReuse() {
        self.messageLabel.text = nil
    }

}
