//
//  WishListViewController.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/26/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class WishListViewController: ItemListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func deleteItem(cell : UITableViewCell, item : Any, index : Int) {
        let itemCast = item as! Wish
        itemCast.delete { (code) in}
        self.wishList?.remove(at: index)
        self.deleteCell(cell)
    }
    
}
