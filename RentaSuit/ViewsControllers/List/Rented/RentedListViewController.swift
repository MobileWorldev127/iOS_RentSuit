//
//  RentedListViewController.swift
//  RentaSuit
//
//  Created by macos on 6/11/20.
//  Copyright © 2020 MacBook Pro. All rights reserved.
//

import Foundation

class RentedListViewController: ItemListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func deleteItem(cell : UITableViewCell, item : Any, index : Int) {
        let item = item as! RentedProduct
//        itemCast.delete { (code) in}
//        self.wishList?.remove(at: index)
//        self.deleteCell(cell)
    }
    
}
