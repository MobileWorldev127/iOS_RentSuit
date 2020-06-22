//
//  WishListViewController.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/25/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
protocol WishListDelegate : AnyObject {
    func setupHomePager(index:NSInteger)
}

class ItemListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, CellActionDelegate, CartPopUpDelegate {
    
    weak var delegate: WishListDelegate?
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeOrderBtn: UIButton!
    
    var wishList : [Wish]?
    var cartList: [Cart]?
    var rentedList: [RentedProduct]?
    var forRentAddedProductList: [AddedProduct]?
    
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
        } else if self is ForRentListViewController {
            return (nil != forRentAddedProductList) ? forRentAddedProductList!.count : 0
        } else{
            return (nil != cartList) ? cartList!.count : 0
        }
    }
    @IBAction func didTapContinue(_ sender: Any) {
      if self is WishListViewController {
        self.navigationController?.popViewController(animated: true)
        self.delegate!.setupHomePager(index: 1)
      } else {
        var arr : [Int] = []
        for (index, item) in self.cartList!.enumerated(){
          Wish.getItemDetails(String(item.productID)) { (detail, code) in
            arr.append(Int((detail?.retailPrice!)!)!)
            if (index == self.cartList!.count - 1 ) {
              let cartPopup :CartPopupViewController = CartPopupViewController.init(nibName: "CartPopupViewController", bundle: nil)
              cartPopup.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
              cartPopup.cartList = self.cartList
              cartPopup.retailPriceList = arr
              cartPopup.delegate = self
              self.present(cartPopup, animated: false, completion: nil)
            }
          }
        }
      }
    }
  
    func moveToRentedView() {
      self.startLoading()
      Cart.cartList(callBack:{ (products, code) in
          self.stopLoading()
          self.cartList = products
          self.tableView.reloadData()
      })
    }
  
  
    
    @IBAction func didTapBack(_ sender: Any) {
      let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
      self.navigationController?.popToViewController(viewControllers[1], animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        if self is WishListViewController {
            cell.setUp(wish: self.wishList![indexPath.row])
        } else if self is RentedListViewController {
            cell.setUp(rentedProduct: self.rentedList![indexPath.row])
        } else if self is ForRentListViewController {
            cell.setUp(addedProduct: self.forRentAddedProductList![indexPath.row])
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
    
    func detailRetailPrice(_ cell: UITableViewCell, _ action: Action) {
      showAlertView(title: "", message: "A deposit will be retrieved from your credit card upon the owner of the item receives the item back satisfactorily")
    }
  
    func didEditItem(_ cell: UITableViewCell, _ action: Action) {
      let indexPath = self.tableView.indexPath(for: cell)
      let item = forRentAddedProductList![(indexPath?.row)!]
      AddedProductDetailItem.addedProductDetail(String(item.id)){ (products, code) in
        let vc  = self.getViewControllerInstance(sbId: "Rent",vcId: "create_rent_screen") as! CreateRentViewController
        vc.item = products
        self.navigationController?.pushViewController(vc, animated: true)
      }
    }
  
    func didRemoveItem(_ cell: UITableViewCell, _ action: Action) {
      let indexPath = self.tableView.indexPath(for: cell)
      let item = forRentAddedProductList![(indexPath?.row)!]
      let alert = UIAlertController(title: "", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
      alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
          switch action.style{
            case .default:
              let item = self.forRentAddedProductList![(indexPath?.row)!]
              AddedProduct.removeAddedProduct(String(item.id)) {(message) in
                self.removeForRentItem()
              }
            case .cancel:
                  print("cancel")

            case .destructive:
                  print("destructive")
          }
      }))
      self.present(alert, animated: true, completion: nil)
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
  
    func removeForRentItem(){
      AddedProduct.myAddedProductList {(rentedProducts, code) in
        self.stopLoading()
        self.forRentAddedProductList = rentedProducts
        self.tableView.reloadData()
      }
    }
    
    func deleteItem( cell : UITableViewCell, item : Any, index : Int)  {
    
    }

}
