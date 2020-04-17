//
//  ProductSlide.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/15/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit

class ProductSlide: UIView {
    @IBOutlet weak var productImage: WebImageView!
    
    
    class func clone() -> ProductSlide {
        let slide:ProductSlide = Bundle.main.loadNibNamed("ProductSlide", owner: self, options: nil)?.first as! ProductSlide
        return slide
    }
    func setUpSlide(_ picture: Picture) {
        if picture.picture != nil {
            let urlwithPercentEscapes =  (kBaseUrlImage + picture.picture!).addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string:urlwithPercentEscapes!)!
            self.productImage.setImageWith(url, placeholderImage: UIImage(named: "placeholder-test"))
        }
    }
    
}
