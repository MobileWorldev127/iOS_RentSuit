//
//  HomeCollectionViewCell.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 14/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import AFNetworking

class HomeCollectionViewCell: UICollectionViewCell {
    var productSelected : Product?
    
    @IBOutlet weak var imageHomeCell: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var favoritetBtn: UIButton!
    var removeOrAddWishListBlock: ((Bool)->Void)?

    @IBAction func favoriteBtnPressed(_ sender: UIButton) {


//        sender.isSelected = !sender.isSelected
       
        if removeOrAddWishListBlock != nil {
            self.removeOrAddWishListBlock!(true)
        }
        if sender.isSelected {
            if removeOrAddWishListBlock != nil {
                self.removeOrAddWishListBlock!(true)
            }
        }else{
            if removeOrAddWishListBlock != nil {
                self.removeOrAddWishListBlock!(false)
            }
        }
    }
    
    func setupCellWithProduct(product:Product)  {
        if (product.price != nil) {
            self.priceLabel.text = "$" + product.price! + "/hr"
        }
        self.markLabel.text = product.name
        self.favoritetBtn.isSelected = product.onWishlist
        let placeHolder : UIImage? = UIImage.init(named: "placeholder-test")
        if (product.picture != nil) {
            let urlwithPercentEscapes =  (kBaseUrlImage + product.picture!).addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let url:URL = URL(string:urlwithPercentEscapes!)!
            self.imageHomeCell.setImageWith(url, placeholderImage: placeHolder)
            self.imageHomeCell.contentMode = UIViewContentMode.scaleAspectFill;
//            self.imageHomeCell.setImageFromUrl(kBaseUrlImage + product.picture! , placeHolder: placeHolder)
        }else{
//            self.imageHomeCell.setImageFromUrl(nil, placeHolder: placeHolder)
        }
        
    }
    
//    func removeFromWishlitList(product:Product)  {
//        var params : Dictionary<String , AnyObject> = [:]
//        params["product_id"] = product.id as AnyObject
//        params ["on_wishlist"] = 0 as AnyObject
//      
//        Product.addOrRemoveProductwishlist(credentials: params as! Dictionary<String, NSObject>) { (removed, err) in
//            if (err == nil ){
//                if (removed != nil){
//                    if (removed! ){
//                        self.favoritetBtn.isSelected = false
//                    }else{
//                        self.favoritetBtn.isSelected = true
//                    }
//                }
//            }
//            
//        }
//    }
//    func addInWishlitList(product:Product)  {
//        var params : Dictionary<String , AnyObject> = [:]
//        params["product_id"] = product.id as AnyObject
//        params ["on_wishlist"] = 1 as AnyObject
//        
//        Product.addOrRemoveProductwishlist(credentials: params as! Dictionary<String, NSObject>) { (removed, err) in
//            if (err == nil ){
//                if (removed != nil){
//                    if (removed! ){
//                        self.favoritetBtn.isSelected = true
//                    }else{
//                        self.favoritetBtn.isSelected = false
//                    }
//                }
//            }
//            
//        }
//    }
}
