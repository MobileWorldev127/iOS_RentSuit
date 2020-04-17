//
//  User.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 07/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit

public class User  : NSObject, NSCoding, MABMapper{
    
    
    @objc var id : String?
    @objc var status : String?
    @objc var firebaseId : String?
    @objc var firstName : String?
    @objc var lastName : String?
    @objc var profilePictureCustomSize : String?
    @objc var profilePicture : String?
    @objc var sessionToken : String?
    
    var bearerToken : String {
        return String(format: "Bearer %@", sessionToken!)
    }
    
    func displayName() -> String {
        var t = ""
        if let fn = firstName { t = fn }
        if let ln = lastName { t = t + " " + ln }
        return t.capitalized
    }
    
    class func map() -> Dictionary<String, Any>{
        return [
            "id" : [
                "class" : NSString.self,
                "path" : "id",
                "required" : true,
                "array" : false
            ],
            "status" : [
                "class" : NSString.self,
                "path" : "status",
                "required" : false,
                "array" : false
            ],
            "firebaseId" : [
                "class" : NSString.self,
                "path" : "firebase_id",
                "required" : false,
                "array" : false
            ],
            "firstName" : [
                "class" : NSString.self,
                "path" : "first_name",
                "required" : false,
                "array" : false
            ],
            "lastName" : [
                "class" : NSString.self,
                "path" : "last_name",
                "required" : false,
                "array" : false
            ],
            "sessionToken" : [
                "class" : NSString.self,
                "path" : "api_token",
                "required" : false,
                "array" : false
            ]
            ,
            "profilePictureCustomSize" : [
                "class" : NSString.self,
                "path" : "profile_picture_custom_size",
                "required" : false,
                "array" : false
            ]
            ,
            "profilePicture" : [
                "class" : NSString.self,
                "path" : "profile_picture",
                "required" : false,
                "array" : false
            ]
        ]
    }
    
    override init() {
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject( forKey: "id") as? String
        self.status = aDecoder.decodeObject( forKey: "status") as? String
        self.firstName = aDecoder.decodeObject( forKey: "firstName") as? String
        self.lastName = aDecoder.decodeObject( forKey: "lastName") as? String
        self.sessionToken = aDecoder.decodeObject( forKey: "sessionToken") as? String
        self.firebaseId = aDecoder.decodeObject( forKey: "firebaseId") as? String
        self.profilePicture = aDecoder.decodeObject( forKey: "profilePicture") as? String
        self.profilePictureCustomSize = aDecoder.decodeObject( forKey: "profilePictureCustomSize") as? String
        
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(firebaseId, forKey: "firebaseId")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(sessionToken, forKey: "sessionToken")
        aCoder.encode(profilePictureCustomSize, forKey: "profilePictureCustomSize")
        
    }
    
    public class func register( credentials : Dictionary <String , NSObject>, callBack:@escaping (User?,Error?) -> Void) -> Void {
        let request =
            RequestBuilder.buildPostFormDataRequest(url: kBaseUrl + "signup", requireAuth: false, pathParams: nil, queryParams : nil, body: credentials)
        DispatchQueue.main.async {
            LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        }
        
        URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?,error: Error?) in
            DispatchQueue.main.async {
                LoadingOverlay.shared.hideOverlayView()
            }
            
            if (error == nil) && (data != nil) {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String,Any>
                    
                    //                    let code:Int? = result["code"]! as? Int
                    //                    if code == 200  {
                    if result["data"] != nil && result["data"] is NSDictionary{
                        let data:NSDictionary  = result["data"]! as! NSDictionary;
                        
                        if data["user_details"] != nil && data["user_details"] is NSDictionary{
                            let userDetails:Dictionary<String,Any>  = data["user_details"] as! Dictionary<String,Any>;
                            let user = MABMapperFetcher<Any>.fetch(dictionary: userDetails, type: User.self) as? User
                            if user != nil {
                                DispatchQueue.main.async {
                                    User.connect(loggedUser: user!)
                                    callBack(user,nil)
                                }
                            }else{
                                DispatchQueue.main.async {
                                    if result["msg"] is NSDictionary && result["msg"] != nil && result["data"] is NSNull{
                                        let errorTemp = NSError(domain:"", code:101, userInfo:result["msg"]!  as? [String : Any])
                                        callBack(nil,errorTemp)
                                        
                                    }else if result["msg"] is NSString && result["msg"] != nil {
                                        let errorTemp = NSError(domain:result["msg"]! as! String, code:101, userInfo:nil)
                                        callBack(nil,errorTemp)
                                    }else{
                                        callBack(nil,nil)
                                        
                                    }
                                }
                            }
                        }else{
                            DispatchQueue.main.async {
                                if result["msg"] is NSDictionary && result["msg"] != nil && result["data"] is NSNull{
                                    let errorTemp = NSError(domain:"", code:101, userInfo:result["msg"]!  as? [String : Any])
                                    callBack(nil,errorTemp)
                                    
                                }else if result["msg"] is NSString && result["msg"] != nil {
                                    let errorTemp = NSError(domain:result["msg"]! as! String, code:101, userInfo:nil)
                                    callBack(nil,errorTemp)
                                }else{
                                    callBack(nil,nil)
                                    
                                }
                                
                            }
                        }
                        
                    }else{
                        DispatchQueue.main.async {
                            if result["msg"] is NSDictionary && result["msg"] != nil && result["data"] is NSNull{
                                let errorTemp = NSError(domain:"wrongData", code:101, userInfo:result["msg"]!  as? [String : Any])
                                callBack(nil,errorTemp)
                                
                            }else if result["msg"] is NSString && result["msg"] != nil {
                                let errorTemp = NSError(domain:result["msg"]! as! String, code:101, userInfo:nil)
                                callBack(nil,errorTemp)
                            }else{
                                callBack(nil,error)
                                
                            }
                        }
                    }
                    
                    //                        }else{
                    //                            DispatchQueue.main.async {
                    //                                callBack(nil,error)
                    //                            }
                    //                        }
                    
                } catch {
                    DispatchQueue.main.async {
                        callBack(nil,error)
                    }
                    
                }
            }else{
                var sessionError : Error?;
                if error == nil {
                    sessionError = NSError(domain:"NO DATA ERROR", code:-12332, userInfo:nil) as Error
                }else{
                    sessionError = error
                }
                DispatchQueue.main.async {
                    callBack(nil,sessionError)
                }
            }
            }.resume()
    }
    
    public class func Login( credentials : Dictionary <String , NSObject>, callBack:@escaping (User?,Error?) -> Void) -> Void {
        let request =
            RequestBuilder.buildPostFormDataRequest(url: kBaseUrl + "signin", requireAuth: false, pathParams: nil, queryParams : nil, body: credentials)
        DispatchQueue.main.async {
            LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        }
        
        URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?,error: Error?) in
            DispatchQueue.main.async {
                LoadingOverlay.shared.hideOverlayView()
            }
            if (error == nil) && (data != nil) {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String,Any>
                    
                    if result["data"] != nil && result["data"] is NSDictionary{
                        let data:NSDictionary  = result["data"]! as! NSDictionary;
                        
                        if data["user_details"] != nil && data["user_details"] is NSDictionary{
                            let userDetails:Dictionary<String,Any>  = data["user_details"] as! Dictionary<String,Any>;
                            let user = MABMapperFetcher<Any>.fetch(dictionary: userDetails, type: User.self) as? User
                            if user != nil {
                                DispatchQueue.main.async {
                                    User.connect(loggedUser: user!)
                                    callBack(user,nil)
                                }
                            }else{
                                DispatchQueue.main.async {
                                    if result["msg"] is NSDictionary && result["msg"] != nil && result["data"] is NSNull{
                                        let errorTemp = NSError(domain:"", code:101, userInfo:result["msg"]!  as? [String : Any])
                                        callBack(nil,errorTemp)
                                        
                                    }else if result["msg"] is NSString && result["msg"] != nil {
                                        let errorTemp = NSError(domain:result["msg"]! as! String, code:101, userInfo:nil)
                                        callBack(nil,errorTemp)
                                    }else{
                                        callBack(nil,nil)
                                        
                                    }
                                }
                            }
                        }else{
                            DispatchQueue.main.async {
                                if result["msg"] is NSDictionary && result["msg"] != nil && result["data"] is NSNull  {
                                    let errorTemp = NSError(domain:"", code:101, userInfo:result["msg"]!  as? [String : Any])
                                    callBack(nil,errorTemp)
                                    
                                }else if result["msg"] is NSString && result["msg"] != nil {
                                    let errorTemp = NSError(domain:result["msg"]! as! String, code:101, userInfo:nil)
                                    callBack(nil,errorTemp)
                                }else{
                                    callBack(nil,nil)
                                    
                                }
                                
                            }
                        }
                        
                    }else{
                        DispatchQueue.main.async {
                            if result["msg"] is NSDictionary && result["msg"] != nil && result["data"] is NSNull{
                                let errorTemp = NSError(domain:"", code:101, userInfo:result["msg"]!  as? [String : Any])
                                callBack(nil,errorTemp)
                                
                            }else if result["msg"] is NSString && result["msg"] != nil {
                                let errorTemp = NSError(domain:result["msg"]! as! String, code:101, userInfo:nil)
                                callBack(nil,errorTemp)
                            }else{
                                callBack(nil,error)
                                
                            }
                        }
                    }
                    
                    
                } catch {
                    DispatchQueue.main.async {
                        callBack(nil,error)
                    }
                    
                }
            }else{
                var sessionError : Error?;
                if error == nil {
                    sessionError = NSError(domain:"NO DATA ERROR", code:-12332, userInfo:nil) as Error
                }else{
                    sessionError = error
                }
                DispatchQueue.main.async {
                    callBack(nil,sessionError)
                }
            }
            }.resume()
    }
    
    public class func ForgotPsw( credentials : Dictionary <String , NSObject>, callBack:@escaping (String?,Error?) -> Void) -> Void {
        let request =
            RequestBuilder.buildPostFormDataRequest(url: kBaseUrl + "forgotpassword", requireAuth: false, pathParams: nil, queryParams : nil, body: credentials)
        DispatchQueue.main.async {
            LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        }
        URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?,error: Error?) in
            DispatchQueue.main.async {
                LoadingOverlay.shared.hideOverlayView()
            }
            if (error == nil) && (data != nil) {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String,Any>
                    
                    if result["code"] != nil && result["code"] is String{
                        let code:String  = result["code"]! as! String;
                        
                        if code  == "200"{
                            DispatchQueue.main.async {
                                callBack("succes",nil)
                            }
                        }else{
                            DispatchQueue.main.async {
                                if result["msg"] is NSDictionary && result["msg"] != nil && result["data"] is NSNull{
                                    let errorTemp = NSError(domain:"", code:101, userInfo:result["msg"]!  as? [String : Any])
                                    callBack(nil,errorTemp)
                                    
                                }else if result["msg"] is NSString && result["msg"] != nil {
                                    let errorTemp = NSError(domain:result["msg"]! as! String, code:101, userInfo:nil)
                                    callBack(nil,errorTemp)
                                }else{
                                    callBack(nil,nil)
                                    
                                }
                            }
                        }
                        
                        
                    }else{
                        DispatchQueue.main.async {
                            if result["msg"] is NSDictionary && result["msg"] != nil && result["data"] is NSNull{
                                let errorTemp = NSError(domain:"", code:101, userInfo:result["msg"]!  as? [String : Any])
                                callBack(nil,errorTemp)
                                
                            }else if result["msg"] is NSString && result["msg"] != nil {
                                let errorTemp = NSError(domain:result["msg"]! as! String, code:101, userInfo:nil)
                                callBack(nil,errorTemp)
                            }else{
                                callBack(nil,error)
                                
                            }
                        }
                    }
                    
                    
                } catch {
                    DispatchQueue.main.async {
                        callBack(nil,error)
                    }
                    
                }
            }else{
                var sessionError : Error?;
                if error == nil {
                    sessionError = NSError(domain:"NO DATA ERROR", code:-12332, userInfo:nil) as Error
                }else{
                    sessionError = error
                }
                DispatchQueue.main.async {
                    callBack(nil,sessionError)
                }
            }
            }.resume()
    }
    
    public class func editPassword( new : String, old : String, callBack:@escaping (String?) -> Void) -> Void {
        
        let params = ["current_password" : old,
                      "new_password" : new]
        let request =
            RequestBuilder.buildPostFormDataRequest(url: kBaseUrl + "change_password", requireAuth: true, pathParams: nil, queryParams : nil, body: params as Dictionary<String, NSObject>)
        
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
    
    /* connect CurrentUser which is the response of login / subscription request */
    
    static private var _current : User?
    
    static func current() -> User? {
        if _current != nil {
            return _current
        }
        let decoded  = UserDefaults(suiteName: "group.rentaSuit")!.object(forKey: "current_user") as? Data
        if decoded == nil{
            return nil
        }
        _current = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as? User
        return _current
    }
    
    
    static func connect ( loggedUser : User) {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: loggedUser)
        UserDefaults(suiteName: "group.rentaSuit")!.set(encodedData, forKey: "current_user")
        UserDefaults(suiteName: "group.rentaSuit")!.synchronize()
        _current = nil
    }
    
    static func isConnected() -> Bool {
        return  nil != current()
    }
    
    static func logout(){
        _current = nil
        UserDefaults(suiteName: "group.rentaSuit")!.removeObject(forKey: "current_user")
        UserDefaults(suiteName: "group.rentaSuit")!.synchronize()
    }
    
    
    public class func signInWithSocial( credentials : Dictionary <String , NSObject>, callBack:@escaping (User?,Error?) -> Void) -> Void {
        let request =
            RequestBuilder.buildPostRequest(url: kBaseUrl + "social", requireAuth: false, pathParams: nil, queryParams : nil, body: credentials)
        DispatchQueue.main.async {
            LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        }
        
        URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?,error: Error?) in
            DispatchQueue.main.async {
                LoadingOverlay.shared.hideOverlayView()
            }
            
            if (error == nil) && (data != nil) {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String,Any>
                    
                    //                    let code:Int? = result["code"]! as? Int
                    //                    if code == 200  {
                    if result["data"] != nil && result["data"] is NSDictionary{
                        let data:NSDictionary  = result["data"]! as! NSDictionary;
                        
                        if data["user_details"] != nil && data["user_details"] is NSDictionary{
                            let userDetails:Dictionary<String,Any>  = data["user_details"] as! Dictionary<String,Any>;
                            let user = MABMapperFetcher<Any>.fetch(dictionary: userDetails, type: User.self) as? User
                            if user != nil {
                                DispatchQueue.main.async {
                                    User.connect(loggedUser: user!)
                                    callBack(user,nil)
                                }
                            }else{
                                DispatchQueue.main.async {
                                    if result["msg"] is NSDictionary && result["msg"] != nil && result["data"] is NSNull{
                                        let errorTemp = NSError(domain:"", code:101, userInfo:result["msg"]!  as? [String : Any])
                                        callBack(nil,errorTemp)
                                        
                                    }else if result["msg"] is NSString && result["msg"] != nil {
                                        let errorTemp = NSError(domain:result["msg"]! as! String, code:101, userInfo:nil)
                                        callBack(nil,errorTemp)
                                    }else{
                                        callBack(nil,nil)
                                        
                                    }
                                }
                            }
                        }else{
                            DispatchQueue.main.async {
                                if result["msg"] is NSDictionary && result["msg"] != nil && result["data"] is NSNull{
                                    let errorTemp = NSError(domain:"", code:101, userInfo:result["msg"]!  as? [String : Any])
                                    callBack(nil,errorTemp)
                                    
                                }else if result["msg"] is NSString && result["msg"] != nil {
                                    let errorTemp = NSError(domain:result["msg"]! as! String, code:101, userInfo:nil)
                                    callBack(nil,errorTemp)
                                }else{
                                    callBack(nil,nil)
                                    
                                }
                                
                            }
                        }
                        
                    }else{
                        DispatchQueue.main.async {
                            if result["msg"] is NSDictionary && result["msg"] != nil && result["data"] is NSNull{
                                let errorTemp = NSError(domain:"wrongData", code:101, userInfo:result["msg"]!  as? [String : Any])
                                callBack(nil,errorTemp)
                                
                            }else if result["msg"] is NSString && result["msg"] != nil {
                                let errorTemp = NSError(domain:result["msg"]! as! String, code:101, userInfo:nil)
                                callBack(nil,errorTemp)
                            }else{
                                callBack(nil,error)
                                
                            }
                        }
                    }
                  
                } catch {
                    DispatchQueue.main.async {
                        callBack(nil,error)
                    }
                    
                }
            }else{
                var sessionError : Error?;
                if error == nil {
                    sessionError = NSError(domain:"NO DATA ERROR", code:-12332, userInfo:nil) as Error
                }else{
                    sessionError = error
                }
                DispatchQueue.main.async {
                    callBack(nil,sessionError)
                }
            }
            }.resume()
    }
    
}
