//
//  ItemCell.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/25/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
enum Action {
    case add
    case edit
    case delete
}
protocol CellActionDelegate {
    func didRequest(_ cell :UITableViewCell ,_ action : Action)
}

class ItemCell: UITableViewCell {

    @IBOutlet weak var designerValueLabel: UILabel!
    @IBOutlet weak var seasonValueLabel: UILabel!
    @IBOutlet weak var categoryValueLabel: UILabel!
    @IBOutlet weak var locationValueLabel: UILabel!
    @IBOutlet weak var sizeValueLabel: UILabel!
    @IBOutlet weak var colorValueLabel: UILabel!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    var delegate : CellActionDelegate?
    
    func setUp(wish : Wish) {
        self.designerValueLabel.text = wish.designer
        self.sizeValueLabel.text = wish.size
        self.seasonValueLabel.text = wish.season
        self.locationValueLabel.text = wish.location
        self.colorValueLabel.text = wish.color
        self.categoryValueLabel.text = Category.categoryWithId(wish.category)
        
        if (wish.picture != nil) {
            let urlwithPercentEscapes =  (kBaseUrlImage + wish.picture!).addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let url:URL = URL(string:urlwithPercentEscapes!)!
            self.itemImage.setImageWith(url, placeholderImage: UIImage(named: "placeholder-test"))
        }
    }
    
    func setUp(cart : Cart) {
        self.designerValueLabel.text = "cart."
        self.sizeValueLabel.text = "cart.size"
        self.seasonValueLabel.text = "cart.season"
        self.locationValueLabel.text = "cart.location"
        self.colorValueLabel.text = "cart.productDetail."
        self.categoryValueLabel.text = "cart.category"//Category.categoryWithId(cart.category)
        
        if (cart.productDetail.picture != nil) {
            let urlwithPercentEscapes =  (kBaseUrlImage + cart.productDetail.picture).addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let url:URL = URL(string:urlwithPercentEscapes!)!
            self.itemImage.setImageWith(url, placeholderImage: UIImage(named: "placeholder-test"))
        }
    }
    
    
    @IBAction func didTapDelete(_ sender : UIButton) {
        if nil != self.delegate {
            self.delegate?.didRequest(self, .delete)
        }
    }

}
