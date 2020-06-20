//
//  CreateRentViewController.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 11/9/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class CreateRentViewController: BaseViewController, ImagePickerDelegate, MissingPermissionToUseCamera, PickableValuesTextFieldDelegate {

    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var itemNameInput: UITextField!
    @IBOutlet weak var itemRetailPriceInput: UITextField!
    @IBOutlet weak var itemPricePerHourInput: UITextField!
    @IBOutlet weak var itemColorInput: UITextField!
    @IBOutlet weak var itemSizeInput: PickableDataTextField!
    @IBOutlet weak var itemCategoryInput: PickableDataTextField!
    @IBOutlet weak var itemAlterationInput: PickableDataTextField!
    @IBOutlet weak var itemConditionInput: PickableDataTextField!
    @IBOutlet weak var itemSeasonInput: PickableDataTextField!
    @IBOutlet weak var itemCancelationInput: PickableDataTextField!
    @IBOutlet weak var itemDesignerInput: UITextField!
    @IBOutlet weak var itemDescriptionInput: UITextField!
    @IBOutlet weak var itemCleanPriceInput: UITextField!
  
    var item: AddedProductDetailItem?
    
    @IBAction func didTapCreate(_ sender: Any) {
        var params = [String : NSObject]()
        if String.isValid(itemNameInput.text) {
            params["name"] = itemNameInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(itemRetailPriceInput.text) {
            params["retail_price"] = itemRetailPriceInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(itemPricePerHourInput.text) {
            params["price"] = itemPricePerHourInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(itemColorInput.text) {
            params["color"] = itemColorInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(itemSizeInput.text) {
          params["size"] = itemSizeInput.text?.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(itemCategoryInput.text) {
          if (itemCategoryInput.text! == "Suits") {
            params["category_id"] = "1".toObject
          }
          if (itemCategoryInput.text! == "Dress") {
            params["category_id"] = "2".toObject
          }
          if (itemCategoryInput.text! == "Jackets") {
            params["category_id"] = "3".toObject
          }
          if (itemCategoryInput.text! == "Coats") {
            params["category_id"] = "4".toObject
          }
          if (itemCategoryInput.text! == "Tops") {
            params["category_id"] = "5".toObject
          }
          if (itemCategoryInput.text! == "Accessories") {
            params["category_id"] = "6".toObject
          }
          if (itemCategoryInput.text! == "Skirt") {
            params["category_id"] = "7".toObject
          }
          if (itemCategoryInput.text! == "Pant") {
            params["category_id"] = "8".toObject
          }
          if (itemCategoryInput.text! == "Bags") {
            params["category_id"] = "9".toObject
          }
          if (itemCategoryInput.text! == "Shoes") {
            params["category_id"] = "10".toObject
          }
          if (itemCategoryInput.text! == "Let's Party") {
            params["category_id"] = "11".toObject
          }
//            params["category"] = itemCategoryInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(itemAlterationInput.text) {
            params["alteration"] = itemAlterationInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(itemConditionInput.text) {
            params["condition"] = itemConditionInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(itemSeasonInput.text) {
            params["season"] = itemSeasonInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(itemCancelationInput.text) {
          if (itemCancelationInput.text! == "AGRESSIVE" || itemCancelationInput.text! == "Aggressive (Item may be cancelled without penalty 9 days and up prior the rental period)") {
            params["cancellation"] = "Aggressive (Item may be cancelled without penalty 9 days and up prior the rental period)".toObject
          }
          if (itemCancelationInput.text! == "MODERATE" || itemCancelationInput.text! == "Moderate (Item may be cancelled without penalty 6-8 days prior the rental period)") {
            params["cancellation"] = "Moderate (Item may be cancelled without penalty 6-8 days prior the rental period)".toObject
          }
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(itemDesignerInput.text) {
            params["designer"] = itemDesignerInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(itemDescriptionInput.text) {
            params["description"] = itemDescriptionInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
      
        if String.isValid(itemCleanPriceInput.text) {
            params["cleaning_price"] = itemCleanPriceInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
      
        self.startLoading()
        if ((self.item) != nil) {
          params["id"] = item?.id as NSObject?

          if nil != selectedImage{
              params["picture"] = selectedImage?.toBase64?.toObject
          }else{
              let url:NSURL = NSURL(string : item!.picture)!
              let imageData:NSData = NSData.init(contentsOf: url as URL)!
              params["picture"] = ("data:image/jpeg;base64," + imageData.base64EncodedString()).toObject
          }
          UpdateAddedProductDetailItem.updateProduct(params: params) { (message) in
              self.stopLoading()
              self.showAlertView(title: nil, message: "Product has been updated.")
          }
        } else {
          if nil != selectedImage{
              params["picture"] = selectedImage?.toBase64?.toObject
          }else{
              self.showAlertView(title: nil, message: "mendatory image")
              return
          }
          Cart.createPost(params: params) { (message) in
              self.stopLoading()
//              self.showAlertView(title: nil, message: "Product added to cart.")
              let alert = UIAlertController(title: "", message: "Product added to cart.", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                  switch action.style{
                    case .default:
                      self.startLoading()
                      AddedProduct.myAddedProductList {(rentedProducts, code) in
                        self.stopLoading()
                        let vc  = self.getViewControllerInstance(sbId: "ForRentList",vcId: "for_rent_list_screen") as! ForRentListViewController
                          vc.forRentAddedProductList = rentedProducts
                        self.navigationController?.pushViewController(vc, animated: true)
                      }
                    case .cancel:
                          print("cancel")

                    case .destructive:
                          print("destructive")
                  }
                
              }))
              self.present(alert, animated: true, completion: nil)
            
            
            
//              self.startLoading()
//              AddedProduct.myAddedProductList {(rentedProducts, code) in
//                self.stopLoading()
//                let vc  = self.getViewControllerInstance(sbId: "ForRentList",vcId: "for_rent_list_screen") as! ForRentListViewController
//                  vc.forRentAddedProductList = rentedProducts
//                self.navigationController?.pushViewController(vc, animated: true)
//              }
          }
        }
    }
    
    var avatarPicker : ImagePicker?
    var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      if ((self.item) != nil) {
        showSetUpInfo()
      } else {
        setUpInfo()
      }
        
        // Do any additional setup after loading the view.
    }
    
    func setUpInfo(){
        setUpSelector(itemSizeInput, dataSet: sizeSet, action: .both)
        setUpSelector(itemCategoryInput, dataSet: Category.cached()?.map({ (category) -> String in
            category.name ?? ""
        }), action: .both)
        
        setUpSelector(itemAlterationInput, dataSet: altarationSet, action: .both)
        setUpSelector(itemConditionInput, dataSet: conditionSet, action: .both)
        setUpSelector(itemSeasonInput, dataSet: seasonSet, action: .both)
        setUpSelector(itemCancelationInput, dataSet: cancelationSet, action: .done)
        
    }
  
    func showSetUpInfo() {
      setUpSelector(itemSizeInput, dataSet: sizeSet, action: .both)
      setUpSelector(itemCategoryInput, dataSet: Category.cached()?.map({ (category) -> String in
          category.name ?? ""
      }), action: .both)
      
      setUpSelector(itemAlterationInput, dataSet: altarationSet, action: .both)
      setUpSelector(itemConditionInput, dataSet: conditionSet, action: .both)
      setUpSelector(itemSeasonInput, dataSet: seasonSet, action: .both)
      setUpSelector(itemCancelationInput, dataSet: cancelationSet, action: .done)
      self.itemNameInput.text = item?.name
      self.itemRetailPriceInput.text = String((item?.retailPrice)!)
      self.itemPricePerHourInput.text = String((item?.price)!)
      self.itemColorInput.text = item?.color
      self.itemDesignerInput.text = item?.designer
      self.itemDescriptionInput.text = item?.detail
      self.itemCleanPriceInput.text = String((item?.cleaningPrice)!)
      self.itemCategoryInput.text = item?.categories?.name
      self.itemSizeInput.text = item?.size
      self.itemAlterationInput.text = item?.alteration
      self.itemConditionInput.text = item?.condition
      self.itemSeasonInput.text = item?.season
      self.itemCancelationInput.text = item?.cancellation
      if (item?.picture != nil) {
        let urlwithPercentEscapes = (item?.picture)!.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
          let url:URL = URL(string:urlwithPercentEscapes!)!
          self.mainImage.setImageWith(url, placeholderImage: UIImage(named: "placeholder-test"))
      }
      
    }
    fileprivate func setUpSelector(_ sender : PickableDataTextField, dataSet : [String]?, action : ExtrasActions) {
        sender.text = dataSet?.first
        sender.dataSet = (dataSet! as [AnyObject])
        sender.extras = action
        sender.pickableDelegate = self
    }
    func didSelectValue(sender: PickableValuesTextField, value: AnyObject?) {
        if value is String {
            sender.text = (value as! String)
        }
    }
    
    func didRequestNext(sender: PickableValuesTextField) {
        
    }
    
    func didRequestDone(sender: PickableValuesTextField) {
        self.view.endEditing(true)
    }
    
    @IBAction func didTapAddPicture(_ sender: Any) {
        if nil == self.avatarPicker {
            avatarPicker = ImagePicker(viewcontroller: self, aDelegate: self)
            avatarPicker?.permissionDelegate = self
        }
        avatarPicker?.choosePictureActionSheet()
    }
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    
    // Avatar handling
    
    func imagePickerDidPickImage(_ pickedImage: UIImage) {
        selectedImage = ImagePicker.resized640WideImage(image: pickedImage)
        mainImage.image = selectedImage
    }
    
    func missingPermission() {
        let alert = UIAlertController(title: nil, message: "permission_camera".localized , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
            } else {
                UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    
}
