//
//  ProfileViewController.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/18/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController, ImagePickerDelegate, MissingPermissionToUseCamera, PickableValuesTextFieldDelegate {

    func didSelectValue(sender: PickableValuesTextField, value: AnyObject?) {
        if value is String {
            sender.text = value as! String
        }
    }
    
    func didRequestNext(sender: PickableValuesTextField) {
        
    }
    
    func didRequestDone(sender: PickableValuesTextField) {
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var notificationBadge: BadgedButton!
    @IBOutlet weak var userAvatar: WebImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    var profile : UserProfile?

    // profile info
    
    
    @IBOutlet weak var userFirstNameTextField: UITextField!
    @IBOutlet weak var userLastNameTextField: UITextField!
    @IBOutlet weak var userPhoneNumberTextField: UITextField!
    @IBOutlet weak var userLocationTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userBirthdayTextField: PickableDateTextField!
    // body info
    
    @IBOutlet weak var infoSizeInput: PickableDataTextField!
    @IBOutlet weak var infoBreastInput: PickableDataTextField!
    @IBOutlet weak var infoHeightInput: PickableDataTextField!
    @IBOutlet weak var infoWaistInput: PickableDataTextField!
    @IBOutlet weak var infoHipsInput: PickableDataTextField!
    
    // billing info
    
     @IBOutlet weak var billingInfoEmailInput: UITextField!
    
    // edit pwd info
    
    @IBOutlet weak var oldPwdInput: UITextField!
    @IBOutlet weak var newPwdInput: UITextField!
    @IBOutlet weak var confirmPwdInput: UITextField!
    @IBOutlet weak var submitChangeButton: UIButton!
    
    var selectedImage : UIImage?
    
    var avatarPicker : ImagePicker?
    
    fileprivate func setUpInfo() {
        if nil != profile?.profilePicture {
            self.userAvatar.setImageFromUrl(kBaseUrlImage + (profile?.profilePicture)!, placeHolder: nil)
        }
        
        self.userNameLabel.text = profile?.displayName()
        
        // profile
        self.userBirthdayTextField.pickableDelegate = self
        self.userBirthdayTextField.extras = .done
    }
    
    func setUpUserInfo(){
        userFirstNameTextField.text = profile?.firstName
        userLastNameTextField.text = profile?.lastName
        userPhoneNumberTextField.text = profile?.contactNumber
        userLocationTextField.text = profile?.location
        userEmailTextField.text = profile?.email
        userBirthdayTextField.text = profile?.birthday
    }
    
    func setUpBodyInfo(){
        infoSizeInput.text = profile?.readableSize
        setUpSelector(infoSizeInput, dataSet: PickerValues.sizeMeasurement, action: .both)
        infoBreastInput.text = profile?.breast
        setUpSelector(infoBreastInput, dataSet: PickerValues.inchesMeasurement, action: .both)
        infoHeightInput.text = profile?.height
        setUpSelector(infoHeightInput, dataSet: PickerValues.feetMeasurement, action: .both)
        infoWaistInput.text = profile?.waist
        setUpSelector(infoWaistInput, dataSet: PickerValues.inchesMeasurement, action: .both)
        infoHipsInput.text = profile?.hips
        setUpSelector(infoHipsInput, dataSet: PickerValues.inchesMeasurement, action: .done)
    }
    
    func setUpBillingInfo(){
        billingInfoEmailInput.text = profile?.paypalEmailAddress
    }
    
    fileprivate func setUpSelector(_ sender : PickableDataTextField, dataSet : [String]?, action : ExtrasActions) {
        sender.dataSet = dataSet as! [AnyObject]
        sender.extras = action
        sender.pickableDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        extrasSetUp()
        setUpInfo()
        setUpUserInfo()
        setUpBodyInfo()
        setUpBillingInfo()
        notificationBadge.addBadgeToButon(badge: "3")
        notificationBadge.setImage(UIImage(named: "ic_bell")?.withRenderingMode(.alwaysTemplate), for: .normal)

    }
    
    func extrasSetUp(){
        userAvatar.clipsToBounds = true
        userAvatar.roundCorners(UIRectCorner.bottomLeft, radius: 10)
    }
    
    @IBAction func didTapSaveChanges(_ sender: Any) {
        var didSetNewVals = false
        var data = [String : NSObject]()
        
        let bodyInfo =  collectBodyUpdateInfo()
        if bodyInfo != nil {
            didSetNewVals = true
            data = data.merging(bodyInfo!, uniquingKeysWith: { $1 })
        }
        
        let personalInfo =  collectPersonalUpdateInfo()
        if personalInfo != nil {
            didSetNewVals = true
            data = data.merging(personalInfo!, uniquingKeysWith: { $1 })
        }
        
        let billingInfo =  collectBillingUpdateInfo()
        if billingInfo != nil {
            didSetNewVals = true
            data = data.merging(billingInfo!, uniquingKeysWith: { $1 })
        }
        
        if nil != selectedImage {
            data["profile_picture"] = selectedImage!.toBase64?.toObject
            didSetNewVals = true
        }
        
        if !didSetNewVals{
            self.showAlertView(title: "no update", message: nil)
        }else{
            self.startLoading()
            UserProfile.updateProfile(data) { (code) in
                self.stopLoading()
                self.showAlertView(title: code, message: nil)
            }
        }
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapEditUserInfo(_ sender: Any) {
            if nil == self.avatarPicker {
                avatarPicker = ImagePicker(viewcontroller: self, aDelegate: self)
                avatarPicker?.permissionDelegate = self
            }
            avatarPicker?.choosePictureActionSheet()
    }
    
    @IBAction func didTapChangePwd(_ sender: Any) {
        if !(String.isValid(oldPwdInput.text) &&
            String.isValid(newPwdInput.text) &&
            String.isValid(confirmPwdInput.text)) {
            showAlertView(title: nil, message: "all_fields_required")
            return
        }
        
        if newPwdInput.text != confirmPwdInput.text {
            showAlertView(title: nil, message: "confirm_not_equal")
            return
        }
        self.startLoading()
        User.editPassword(new: newPwdInput.text!, old: oldPwdInput.text!) { (code) in
            self.stopLoading()
            if code == "200" {
                self.showAlertView(title: nil, message: "success_pwd_edit")
                return
            }
            
            if code == "101" {
                self.showAlertView(title: nil, message: "wrong_old_pwd")
                return
            }
            
            self.showAlertView(title: nil, message: "error")
            return
        }
    }

    // Avatar handling
    
    func imagePickerDidPickImage(_ pickedImage: UIImage) {
        selectedImage = ImagePicker.resized640WideImage(image: pickedImage)
        userAvatar.image = selectedImage
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
    
    @IBAction func goToNotification(_ sender: Any) {
        startLoading()
        Notif.notifList(nil, nil) { (notifs, code) in
            self.stopLoading()
            //if notifs != nil {
                let vc = self.getViewControllerInstance(sbId: "Notification", vcId: "notif_screen") as! NotificationsViewController
                //vc.dataSet = notifs!
                self.navigationController?.pushViewController(vc, animated: true)
            //}
        }
    }
    
    
    // get info
    
    func collectPersonalUpdateInfo() -> [String : NSObject]? {
        if view == nil {
            return nil
        }
        var didSetNewVals = false
        var data = [String : NSObject]()
        if String.updatable(userFirstNameTextField.text, original: profile?.firstName) {
            didSetNewVals = true
            data["first_name"] = userFirstNameTextField.text!.toObject
        }
        if String.updatable(userLastNameTextField.text, original: profile?.lastName) {
            didSetNewVals = true
            data["last_name"] = userLastNameTextField.text!.toObject
        }
        if String.updatable(userPhoneNumberTextField.text, original: profile?.contactNumber) {
            didSetNewVals = true
            data["contact_number"] = userPhoneNumberTextField.text!.toObject
        }
        if String.updatable(userLocationTextField.text, original: profile?.location) {
            didSetNewVals = true
            data["location"] = userLocationTextField.text!.toObject
        }
        if String.updatable(userEmailTextField.text, original: profile?.email) {
            didSetNewVals = true
            data["email"] = userEmailTextField.text!.toObject
        }
        
        if String.updatable(userBirthdayTextField.text, original: profile?.birthday) {
            didSetNewVals = true
            data["birthday"] = userBirthdayTextField.text!.toObject
        }
        
        if !didSetNewVals{
            return nil
        }
        
        return data
    }
    
    func collectBodyUpdateInfo() -> [String : NSObject]? {
        var didSetNewVals = false
        var data = [String : NSObject]()
        if String.updatable(infoSizeInput.text, original: profile?.readableSize) {
            didSetNewVals = true
            data["size"] =  PickerValues.sizeMeasurement.firstIndex(of: infoSizeInput.text!) as! NSObject
        }
        if String.updatable(infoBreastInput.text, original: profile?.breast) {
            didSetNewVals = true
            data["breast"] = infoBreastInput.text!.toObject
        }
        if String.updatable(infoHeightInput.text, original: profile?.height) {
            didSetNewVals = true
            data["height"] = infoHeightInput.text!.toObject
        }
        if String.updatable(infoWaistInput.text, original: profile?.waist) {
            didSetNewVals = true
            data["waist"] = infoWaistInput.text!.toObject
        }
        if String.updatable(infoHipsInput.text, original: profile?.hips) {
            didSetNewVals = true
            data["hips"] = infoHipsInput.text!.toObject
        }
        if !didSetNewVals{
            return nil
        }
        
        return data
    }
    
    func collectBillingUpdateInfo() -> [String : NSObject]? {
        var didSetNewVals = false
        var data = [String : NSObject]()
        if String.updatable(billingInfoEmailInput.text, original: profile?.paypalEmailAddress) {
            didSetNewVals = true
            data["paypal_email_address"] = billingInfoEmailInput.text!.toObject
        }
        if !didSetNewVals{
            return nil
        }
        return data
    }
    
    @IBAction func didTapBodyType(_ sender: UIButton) {
        let vc = BodyTypeViewController()
        //present from a view and rect
        vc.selectedBodyType = (self.profile?.bodyType)!
        vc.modalPresentationStyle = .popover //presentation style
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
        vc.popoverPresentationController?.sourceView = view
        vc.popoverPresentationController?.sourceRect = sender.frame
    }
    
    @IBAction func didTapMeasurement(_ sender: UIButton) {
        let vc = MeasurementBoardViewController()
        //present from a view and rect
        vc.modalPresentationStyle = .popover //presentation style
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
        vc.popoverPresentationController?.sourceView = view
        vc.popoverPresentationController?.sourceRect = sender.frame
    }
}

