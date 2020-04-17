//
//  ImagePicker.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 11/1/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation

import UIKit
import MobileCoreServices
import AVFoundation

protocol ImagePickerDelegate {
    func imagePickerDidPickImage(_ pickedImage:UIImage)
}

protocol MissingPermissionToUseCamera {
    func missingPermission()
}

class ImagePicker: NSObject, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var useFrontCamera = false
    
    var pickerDelegate:ImagePickerDelegate?
    var permissionDelegate: MissingPermissionToUseCamera?
    
    var viewController:UIViewController
    
    init(viewcontroller vc:UIViewController, aDelegate:ImagePickerDelegate) {
        viewController = vc
        pickerDelegate = aDelegate
    }
    
    func showActionSheet() {
        choosePictureActionSheet()
    }
    
    func choosePictureActionSheet() {
    let more = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let takePicAction = UIAlertAction(title: NSLocalizedString("av_take_pic", comment: ""), style: .default) { (action) in
            if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.denied
            {
                self.permissionDelegate?.missingPermission()
                return
            }
            if (UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear)) {
                self.viewController.present(self.takePhotoImagePickerController(), animated: true, completion: nil)
            }
        }
        more.addAction(takePicAction)
        
        
        let choosePicAction = UIAlertAction(title: NSLocalizedString("av_chose_pic", comment: ""), style: .default) { (action) in
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)) {
                self.viewController.present(self.pickFromLibraryImagePickerController(), animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title:  NSLocalizedString("av_cancel", comment: ""), style: .cancel, handler: nil)
        
        
        more.addAction(choosePicAction)
        more.addAction(cancelAction)
        
        self.viewController.presentActivityController(activityVC: more, animated: true, sourceView: nil)
        
    }
    
    func takePhotoImagePickerController() -> UIImagePickerController {
        let vc = defaultImagePickerVC()
        vc.sourceType = UIImagePickerControllerSourceType.camera
        let array : NSArray = [kUTTypeImage as AnyObject]
        if let mts =  array as? [String] {
            vc.mediaTypes = mts
        }
        vc.cameraDevice = useFrontCamera ? .front : .rear
        return vc
    }
    
    func pickFromLibraryImagePickerController() -> UIImagePickerController {
        let vc = defaultImagePickerVC()
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        let array : NSArray = [kUTTypeImage as AnyObject]
        if let mts =  array as? [String] {
            vc.mediaTypes = mts
        }
        return vc
    }
    
    func defaultImagePickerVC() -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.delegate = self
        return vc
    }
    
    // MARK : - ImagePicker Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])  {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            viewController.dismiss(animated: true, completion: nil)
            if pickerDelegate != nil {
                pickerDelegate?.imagePickerDidPickImage(image)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)  {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    class func resized640WideImage(image :UIImage) -> UIImage {
        let scale = 640 / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: 640,height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: 640, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
