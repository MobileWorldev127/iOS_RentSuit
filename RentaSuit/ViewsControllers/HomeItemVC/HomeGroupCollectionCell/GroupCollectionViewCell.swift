//
//  GroupCollectionViewCell.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 21/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class GroupCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageGroupView: WebImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func setupCellWithcategory(category:CategoryProduct) {
        self.nameLabel.text = category.name
        let placeHolder : UIImage? = UIImage.init(named: "placeholder-test")
        if (category.picture != nil) {
            let urlwithPercentEscapes =  (kBaseUrlImage + category.picture!).addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let url:URL = URL(string:urlwithPercentEscapes!)!
            self.imageGroupView.setImageWith(url, placeholderImage: placeHolder)
//            self.imageGroupView.setImageFromUrl(kBaseUrlImage + category.picture! , placeHolder: placeHolder)
            
        }else{
//            self.imageGroupView.setImageFromUrl(nil, placeHolder: placeHolder)
        }
    }
}
