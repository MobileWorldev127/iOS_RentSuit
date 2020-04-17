//
//  GarmentsCollectionViewCell.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 15/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class GarmentsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var garmentImageView: WebImageView!
    @IBOutlet weak var stateBtnTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var markLabel: UILabel!
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
}
