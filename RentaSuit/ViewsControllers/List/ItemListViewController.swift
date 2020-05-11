//
//  WishListViewController.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/25/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class ItemListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, CellActionDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var wishList : [Wish]?
    var cartList: [Cart]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self is WishListViewController {
            return (nil != wishList) ? wishList!.count : 0
        }else{
            return (nil != cartList) ? cartList!.count : 0
        }
    }
    @IBAction func didTapContinue(_ sender: Any) {
    }
    
    @IBAction func didTapBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
      let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
      self.navigationController?.popToViewController(viewControllers[1], animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        if self is WishListViewController {
            cell.setUp(wish: self.wishList![indexPath.row])
        }else{
            cell.setUp(cart: self.cartList![indexPath.row])
        }
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self is WishListViewController {
            let item = self.wishList![indexPath.row]
            self.goToItemDetails(item.id!)
        }else{
            let item = self.cartList![indexPath.row]
            self.goToItemDetails(String(item.productDetail.id))
        }
        
    }
    
    func didRequest(_ cell: UITableViewCell, _ action: Action) {
        let indexPath = self.tableView.indexPath(for: cell)
        if indexPath == nil {
            return
        }
        if self is WishListViewController {
            let item = wishList![(indexPath?.row)!]
            deleteItem( cell : cell,item: item, index: (indexPath?.row)!)
        }else{
            let item = cartList![(indexPath?.row)!]
            deleteItem( cell : cell,item: item, index: (indexPath?.row)!)
        }
        
    }
    
    func deleteCell(_ cell: UITableViewCell){
        let indexPath = self.tableView.indexPath(for: cell)
        if indexPath == nil {
            return
        }
        if self.tableView.indexPathsForVisibleRows!.contains(indexPath!) {
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        }
    }
    
    func deleteItem( cell : UITableViewCell, item : Any, index : Int)  {
    
    }

}
