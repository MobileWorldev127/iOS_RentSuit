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
    @IBOutlet weak var intemDescriptionInput: UITextField!
    
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
            params["size"] = PickerValues.sizeMeasurement.firstIndex(of: itemSizeInput.text!) as! NSObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if String.isValid(itemCategoryInput.text) {
            params["category"] = itemCategoryInput.text!.toObject
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
            params["cancellation"] = itemCancelationInput.text!.toObject
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
        
        if String.isValid(intemDescriptionInput.text) {
            params["description"] = intemDescriptionInput.text!.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory field")
            return
        }
        
        if nil != selectedImage{
            params["picture"] = selectedImage?.toBase64?.toObject
        }else{
            self.showAlertView(title: nil, message: "mendatory image")
            return
        }
        self.startLoading()
        Cart.createPost(params: params) { (message) in
            self.stopLoading()
            print(message)
        }
    }
    
    var avatarPicker : ImagePicker?
    var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInfo()
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
