//
//  PickableValuesTextField.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/17/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

enum ExtrasActions {
     case done
     case next
     case both
     case none
}

protocol PickableValuesTextFieldDelegate {
    func didSelectValue( sender : PickableValuesTextField , value : AnyObject? )
    func didRequestNext(sender : PickableValuesTextField)
    func didRequestDone(sender : PickableValuesTextField)
}

class PickableValuesTextField: UITextField {

    var dataSet : [AnyObject]?
    var lastSelected : AnyObject?
    var pickableDelegate : PickableValuesTextFieldDelegate?
    var extras : ExtrasActions = .none
    func setUpInputMethods() {}
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x += rightPadding
        return textRect
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = rightImage {
            rightViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .center
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            rightView = imageView
        } else {
            rightViewMode = UITextFieldViewMode.never
            rightView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: color])
    }
    
}
