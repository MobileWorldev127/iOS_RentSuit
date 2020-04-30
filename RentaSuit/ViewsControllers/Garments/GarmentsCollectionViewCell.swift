//
//  GarmentsCollectionViewCell.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 15/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class GarmentsCollectionViewCell: UICollectionViewCell {
    var productSelected : Product?
  
    @IBOutlet weak var garmentImageView: UIImageView!
    @IBOutlet weak var stateBtnTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var markLabel: UILabel!

  
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoritetBtn: UIButton!
    var removeOrAddWishListBlock: ((Bool)->Void)?
  
    @IBAction func favoriteBtnPressed(_ sender: UIButton) {
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
    
  
    func setTopStateBtnConstarint(index:NSInteger)  {
        if index == 0 {
            self.stateBtnTopConstraint.constant = 42
        }else{
            self.stateBtnTopConstraint.constant = 12

        }
    }
  
    func setupCellWithcategory(category:CategoryProduct) {
        self.markLabel.text = category.name
        let placeHolder : UIImage? = UIImage.init(named: "placeholder-test")
        if (category.picture != nil) {
            let urlwithPercentEscapes =  (kBaseUrlImage + category.picture!).addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let url:URL = URL(string:urlwithPercentEscapes!)!
            self.garmentImageView.setImageWith(url, placeholderImage: placeHolder)
   
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
            self.garmentImageView.setImageWith(url, placeholderImage: placeHolder)
        }
        
    }
}
