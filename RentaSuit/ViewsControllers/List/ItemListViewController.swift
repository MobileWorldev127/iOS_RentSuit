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
    @IBOutlet weak var placeOrderBtn: UIButton!
    
    var wishList : [Wish]?
    var cartList: [Cart]?
    var rentedList: [RentedProduct]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      if (placeOrderBtn != nil && self.cartList?.count == 0){
        placeOrderBtn.isHidden = true
      }else if (placeOrderBtn != nil){
        placeOrderBtn.isHidden = false
      }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self is WishListViewController {
            return (nil != wishList) ? wishList!.count : 0
        } else if self is RentedListViewController {
            return (nil != rentedList) ? rentedList!.count : 0
        } else{
            return (nil != cartList) ? cartList!.count : 0
        }
    }
    @IBAction func didTapContinue(_ sender: Any) {
      var arr : [Int] = []
      for (index, item) in self.cartList!.enumerated(){
        Wish.getItemDetails(String(item.productID)) { (detail, code) in
          arr.append(Int((detail?.retailPrice!)!)!)
          if (index == self.cartList!.count - 1 ) {
            let cartPopup :CartPopupViewController = CartPopupViewController.init(nibName: "CartPopupViewController", bundle: nil)
            cartPopup.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            cartPopup.cartList = self.cartList
            cartPopup.retailPriceList = arr
            self.present(cartPopup, animated: false, completion: nil)
          }
        }        
      }
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
        } else if self is RentedListViewController {
            cell.setUp(rentedProduct: self.rentedList![indexPath.row])
        } else{
            cell.setUp(cart: self.cartList![indexPath.row])
        }
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self is WishListViewController {
            let item = self.wishList![indexPath.row]
            self.goToItemDetails(item.id!)
        } else if self is RentedListViewController {
            let item = self.rentedList![indexPath.row]
            self.goToRentedProductItemDetails(item.rentedId!)
        } else{
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
        } else if self is RentedListViewController {
          let alert = UIAlertController(title: "", message: "Are you sure you want to cancel this booking?", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
          alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
              switch action.style{
                case .default:
                  let item = self.rentedList![(indexPath?.row)!]
                  self.deleteItem( cell : cell,item: item, index: (indexPath?.row)!)
                case .cancel:
                      print("cancel")

                case .destructive:
                      print("destructive")
              }
            
          }))
          self.present(alert, animated: true, completion: nil)
            
        } else{
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
    
    func changeStatus(_ cell: UITableViewCell){
      self.startLoading()
      RentedProduct.myRentedList {(rentedProducts, code) in
        self.stopLoading()
        self.rentedList = rentedProducts
        self.tableView.reloadData()
      }
    }
    
    func deleteItem( cell : UITableViewCell, item : Any, index : Int)  {
    
    }

}
