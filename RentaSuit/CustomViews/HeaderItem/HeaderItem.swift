//
//  HeaderItem.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/24/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit

enum HeaderIndex {
    case home
    case myProfile
    case myCart
    case myWishList
    case garements
    case inTheNews
    case shippingCalculator
    case about
    case contact
    
    var wording : String {
        get{
            switch self {
            case .home:
                return "home_btn".localized
            case .myProfile:
                return "my_profile_btn".localized
            case .myCart:
                return "my_cart_btn".localized
            case .myWishList:
                return "my_wish_list_btn".localized
            case .garements:
                return "garements_btn".localized
            case .inTheNews:
                return "in_the_news_btn".localized
            case .shippingCalculator:
                return "shipping_calculator_btn".localized
            case .about:
                return "about_btn".localized
            case .contact:
                return "contact_btn".localized
            }
        }
    }
}

protocol HeaderItemDelegate {
    func didTapItemAtIndex(_ index : HeaderIndex)
}

class HeaderItem: UIView {
    var index : HeaderIndex?
    var delegate : HeaderItemDelegate?
    
    @IBOutlet weak var button: SelectableButton!
    @IBOutlet weak var indicator: UIView!
    class func clone(_ index : HeaderIndex,delegate : HeaderItemDelegate) -> HeaderItem {
        let view:HeaderItem = Bundle.main.loadNibNamed("HeaderItem", owner: self, options: nil)?.first as! HeaderItem
        view.index = index
        view.button.localizedString = index.wording
        view.delegate = delegate
        return view
    }
    @IBAction func didTapButton(_ SelectableButton: Any) {
        if button.isChecked {
            setSelected(selected: true)
            if nil != self.delegate {
                self.delegate?.didTapItemAtIndex(self.index!)
            }
        }else{
            setSelected(selected: false)
        }
    }
    
    func setSelected(selected : Bool) {
        if selected {
            button.doCheck()
            self.indicator.alpha = 1
        }else{
            button.doUnCheck()
            self.indicator.alpha = 0
        }
    }
    
}
