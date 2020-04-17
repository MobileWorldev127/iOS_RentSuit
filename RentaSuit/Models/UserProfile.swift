//
//  UserProfile.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/19/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class UserProfile: User {

    // contact
    @objc var email : String?
    @objc var contactNumber : String?
    @objc var birthday : String?
    @objc var location : String?
    @objc var country : String?
    @objc var longitude : String?
    @objc var latitude : String?
    
    // body_type
    @objc var bodyType : Int = 1
    @objc var size : Int = -1
    var readableSize : String? {
        get {
            if size != -1{
                if size < PickerValues.sizeMeasurement.count{
                    return PickerValues.sizeMeasurement[size]
                }
                return nil
            }
            return nil
        }
    }
    @objc var height : String?
    @objc var breast : String?
    @objc var waist : String?
    @objc var hips : String?
    
    // extra info
    @objc var displaySize : String?
    @objc var displayHeight : String?
    @objc var displayBreast : String?
    @objc var displayWaist : String?
    @objc var displayHips : String?
    @objc var measurementImage : String?
    
    //billing info
    @objc var paypalEmailAddress : String?

    override class func map() -> Dictionary<String, Any>{
        
        var superMap = super.map()
        
        superMap["email"] = [
            "class" : NSString.self,
            "path" : "email",
            "required" : false,
            "array" : false
        ]
        
        superMap["contactNumber"] = [
            "class" : NSString.self,
            "path" : "contact_number",
            "required" : false,
            "array" : false
        ]
        
        superMap["birthday"] = [
            "class" : NSString.self,
            "path" : "birthday",
            "required" : false,
            "array" : false
        ]
        
        superMap["location"] = [
            "class" : NSString.self,
            "path" : "location",
            "required" : false,
            "array" : false
        ]
        
        superMap["country"] = [
            "class" : NSString.self,
            "path" : "country",
            "required" : false,
            "array" : false
        ]
        
        superMap["longitude"] = [
            "class" : NSString.self,
            "path" : "longitude",
            "required" : false,
            "array" : false
        ]
        
        superMap["size"] = [
            "class" : NSNumber.self,
            "path" : "size",
            "required" : false,
            "array" : false
        ]
        
        superMap["height"] = [
            "class" : NSString.self,
            "path" : "height",
            "required" : false,
            "array" : false
        ]
        
        superMap["breast"] = [
            "class" : NSString.self,
            "path" : "breast",
            "required" : false,
            "array" : false
        ]
        
        superMap["waist"] = [
            "class" : NSString.self,
            "path" : "waist",
            "required" : false,
            "array" : false
        ]
        
        superMap["hips"] = [
            "class" : NSString.self,
            "path" : "hips",
            "required" : false,
            "array" : false
        ]
        
        superMap["bodyType"] = [
            "class" : NSNumber.self,
            "path" : "body_type",
            "required" : false,
            "array" : false
        ]
        
        superMap["latitude"] = [
            "class" : NSString.self,
            "path" : "latitude",
            "required" : false,
            "array" : false
        ]
        
        superMap["paypalEmailAddress"] = [
            "class" : NSString.self,
            "path" : "paypal_email_address",
            "required" : false,
            "array" : false
        ]
        
        superMap["status"] = [
            "class" : NSString.self,
            "path" : "status",
            "required" : false,
            "array" : false
        ]
        
        superMap["displaySize"] = [
            "class" : NSString.self,
            "path" : "display_size",
            "required" : false,
            "array" : false
        ]
        
        superMap["displayHeight"] = [
            "class" : NSString.self,
            "path" : "display_height",
            "required" : false,
            "array" : false
        ]
        
        superMap["displayBreast"] = [
            "class" : NSString.self,
            "path" : "display_breast",
            "required" : false,
            "array" : false
        ]
        
        superMap["displayWaist"] = [
            "class" : NSString.self,
            "path" : "display_waist",
            "required" : false,
            "array" : false
        ]
        
        superMap["displayHips"] = [
            "class" : NSString.self,
            "path" : "display_hips",
            "required" : false,
            "array" : false
        ]
        
        superMap["measurementImage"] = [
            "class" : NSString.self,
            "path" : "measurement_image",
            "required" : false,
            "array" : false
        ]
        
        return superMap
    }
    
    class func loadRemoteProfile(callBack:@escaping (UserProfile?,Int?) -> Void) -> Void {
        
        let request =
            RequestBuilder.buildGetRequest(url: kBaseUrl + "profile", requireAuth: true, pathParams: nil, queryParams: nil)
    
        URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?,error: Error?) in
            if (error == nil) && (data != nil) {
                let httpResponse = response as! HTTPURLResponse
                do {
                    let result = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String,Any>
                    
                    
                    guard let data = result["data"] as? Dictionary<String,Any> else {
                        DispatchQueue.main.async {
                            callBack(nil,426)
                        }
                        return
                    }
                    
                    guard let userProfile = data["user_profile"] as? Dictionary<String,Any> else {
                        DispatchQueue.main.async {
                            callBack(nil,426)
                        }
                        return
                    }
                    
                    let user = MABMapperFetcher<Any>.fetch(dictionary: userProfile, type: UserProfile.self) as? UserProfile
                    if user != nil {
                        DispatchQueue.main.async {
                            callBack(user,nil)
                        }
                    }else{
                        DispatchQueue.main.async {
                            callBack(nil,httpResponse.statusCode)
                        }
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        callBack(nil,httpResponse.statusCode)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    callBack(nil,500)
                }
            }
            }.resume()
        
    }
    
    class func updateProfile(_ data : [String : NSObject],callBack:@escaping (String?) -> Void) -> Void {
        
        let request =
            RequestBuilder.buildPostFormDataRequest(url: kBaseUrl + "profile", requireAuth: true, pathParams: nil, queryParams: nil, body: data)
        URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?,error: Error?) in
            if (error == nil) && (data != nil) {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String,Any>
                    guard let code = result["code"] as? String else {
                        DispatchQueue.main.async {
                            callBack("500")
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        callBack(code)
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        callBack("500")
                    }
                }
            }else{
                DispatchQueue.main.async {
                    callBack("500")
                }
            }
            }.resume()
        
    }
    
}
