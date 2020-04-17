//
//  Extras.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 22/09/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var fromYYYYMMJJText : Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from:self)
    }
    
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    var toObject: NSObject {
        return self as NSObject
    }
 
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    static func isValid(_ string : String?) -> Bool{
        if string == nil {
            return false
        }
        
        if string!.isBlank {
            return false
        }
        
        return true
    }
    
    static func updatable(_ update : String?, original : String?) -> Bool{
        if update == nil {
            return false
        }
        
        if update!.isBlank {
            return false
        }
        
        if update == original {
          return false
        }
        
        return true
    }
    
    var toDouble : Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
}


extension UIImage{
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    var toBase64 : String? {
        get {
            let imageData:NSData = UIImageJPEGRepresentation(self, 0.8) as! NSData
            return imageData.base64EncodedString(options: .lineLength64Characters)
        }
    }
    
}



extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(URL(string: url)!) {
                //application.openURL(URL(string: url)!)
                if #available(iOS 10.0, *) {
                    application.open(URL(string: url)!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(URL(string: url)!)
                }
                return
            }
        }
    }
}

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
}

extension UIButton {
    @IBInspectable
    var localizedString : String? {
        get {
            return self.title(for: UIControlState())
        }
        set {
            if nil == newValue{
                return
            }
            self.setTitle(NSLocalizedString(newValue as! String, comment:""),for: UIControlState())
        }
    }
    
    @IBInspectable
    var selectedLocalizedString: String? {
        get {
            return self.title(for: .selected)
        }
        set {
            if nil == newValue{
                return
            }
            self.setTitle(NSLocalizedString(newValue as! String, comment:""),for: .selected)
        }
        
    }
}

extension UILabel {
    @IBInspectable
    var localizedString : String? {
        get {
            return self.text
        }
        set {
            if nil == newValue{
                return
            }
            self.text = NSLocalizedString(newValue as! String, comment:"")
        }
    }
}

extension UITextField {
    @IBInspectable
    var localizedString : String? {
        get {
            return self.placeholder
        }
        set {
            if nil == newValue{
                return
            }
            self.placeholder = NSLocalizedString(newValue as! String, comment:"")
        }
    }
}

extension UIColor {
    class func yellowApp() -> UIColor {
        return  UIColor(red: 210.0 / 255, green: 173.0 / 255, blue: 82.0 / 255, alpha: 1.0)
    }
    
    class func greyApp() -> UIColor {
        return  UIColor(red: 150.0 / 255, green: 150.0 / 255, blue: 150.0 / 255, alpha: 1.0)
    }
    class func linkBlueApp() -> UIColor {
        return  UIColor(red: 51.0 / 255, green: 122.0 / 255, blue: 183.0 / 255, alpha: 1.0)
    }
    
    class func maleColor() -> UIColor {
        return  UIColor(red: 6.0 / 255, green: 227.0 / 255, blue: 6.0 / 255, alpha: 0.24)
    }
    
    class func femaleColor() -> UIColor {
        return  UIColor(red: 160.0 / 255, green: 4.0 / 255, blue: 4.0 / 255, alpha: 0.24)
    }
    
}


extension UIToolbar {
    
    static func ToolbarPikerWithDone(doneSelector : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("done", comment: "done"), style: .plain, target: nil, action: doneSelector)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    static func ToolbarPikerWithNext(nextSelector : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let next = UIBarButtonItem(title: NSLocalizedString("next", comment: "next"), style: .plain, target: self, action: nextSelector)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, next], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    static func ToolbarPikerWithNextAndDone(nextSelector : Selector, doneSelector : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: NSLocalizedString("done", comment: "done"), style: .plain, target: nil, action: doneSelector)
        let next = UIBarButtonItem(title: NSLocalizedString("next", comment: "next"), style: .plain, target: nil, action: nextSelector)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ doneButton, spaceButton, next], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
}

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}

extension UIViewController {
    func presentActivityController(activityVC : UIViewController, animated : Bool, sourceView : UIView?){
        self.present(activityVC, animated: animated)
        if let popOverVC = activityVC.popoverPresentationController {
            if sourceView == nil {
                popOverVC.sourceView = self.view
                popOverVC.sourceRect = CGRect(x:(self.view.bounds).midX,y:(self.view.bounds).midY,width:0,height:0)
                popOverVC.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                
            }else{
                popOverVC.sourceView = sourceView
                popOverVC.sourceRect = CGRect(x:(sourceView?.bounds)!.midX,y:(sourceView?.bounds)!.midY,width:0,height:0)
                
            }
        }
    }
        
    func add(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
        
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}

extension Date {
    var asYYYYMMJJText : String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from:self)
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
extension Range where Bound == String.Index {
    var nsRange:NSRange {
        return NSRange(location: self.lowerBound.encodedOffset,
                       length: self.upperBound.encodedOffset -
                        self.lowerBound.encodedOffset)
    }
}

extension URL {
    
    static func bodyImage(typeIndex : Int?) -> URL? {
        if typeIndex == nil {
            return nil
        }else{
            return URL(string: String(format : "https://www.rentasuit.ca/user-interface/img/body-type-new-%d.png", typeIndex!))
        }
    }
    
}


