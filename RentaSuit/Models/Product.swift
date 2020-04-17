//
//  Product.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 19/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class Product: NSObject , NSCoding, MABMapper{
    
    
    @objc var id : String?
    @objc var name : String?
    @objc var price : String?
    @objc var picture : String?
    @objc var userDetail : UserProfile?
    @objc var onWishlist : Bool = false
    @objc var avgProductReview :  Int = 0
    @objc var userId :  Int = 0

    
    class func map() -> Dictionary<String, Any>{
        return [
            "id" : [
                "class" : NSString.self,
                "path" : "id",
                "required" : true,
                "array" : false
            ],
            "userId" : [
                "class" : NSNumber.self,
                "path" : "user_id",
                "required" : false,
                "array" : false
            ],
            "name" : [
                "class" : NSString.self,
                "path" : "name",
                "required" : false,
                "array" : false
            ],
            "price" : [
                "class" : NSString.self,
                "path" : "price",
                "required" : false,
                "array" : false
            ],
            "picture" : [
                "class" : NSString.self,
                "path" : "picture",
                "required" : false,
                "array" : false
            ],
            "onWishlist" : [
                "class" : NSNumber.self,
                "path" : "on_wishlist",
                "required" : false,
                "array" : false
            ],
            "avgProductReview" : [
                "class" : NSNumber.self,
                "path" : "avg_product_review",
                "required" : false,
                "array" : false
            ],
            "userDetail" : [
                "class" : UserProfile.self,
                "path" : "user_detail",
                "required" : false,
                "array" : false
            ]
        ]
    }
    
    override init() {
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(  forKey: "id") as? String
        self.userId = aDecoder.decodeInteger(  forKey: "userId") 
        self.name = aDecoder.decodeObject(  forKey: "name") as? String
        self.price = aDecoder.decodeObject(  forKey: "price") as? String
        self.picture = aDecoder.decodeObject(  forKey: "picture") as? String
        self.userDetail = aDecoder.decodeObject(  forKey: "userDetail") as? UserProfile
        self.onWishlist = aDecoder.decodeBool(  forKey: "onWishlist")
        self.avgProductReview = aDecoder.decodeInteger(  forKey: "avgProductReview")
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(picture, forKey: "picture")
        aCoder.encode(onWishlist, forKey: "onWishlist")
        aCoder.encode(userDetail, forKey: "userDetail")
        aCoder.encode(avgProductReview, forKey: "avgProductReview")

        
    }
    
    
    public class func addOrRemoveProductwishlist( credentials : Dictionary <String , NSObject>,callBack:@escaping (Bool?,Error?) -> Void) -> Void {
        let request =
             RequestBuilder.buildPostFormDataRequest(url: kBaseUrl + "product_add_remove_wishlist", requireAuth: false, pathParams: nil, queryParams : nil, body: credentials)
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
                                callBack(true,nil)
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
    
    
    
    public class func filtreProduitWs( credentials : Dictionary <String , NSObject>, callBack:@escaping (HomeProduct?,Error?) -> Void) -> Void {
        var request =
            RequestBuilder.buildGetRequest(url: kBaseUrl + "product_list_filter", requireAuth: true, pathParams: nil, queryParams : nil)
        for (key, element) in credentials {
            request.addValue(String(describing:element), forHTTPHeaderField: key)
        }
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
                            if result["data"] != nil && result["data"] is Dictionary<String,Any>{
                                let productsDetails:Dictionary<String,Any>  = result["data"] as! Dictionary<String,Any>;
                                
                                let homeProduct = MABMapperFetcher<Any>.fetch(dictionary: productsDetails, type: HomeProduct.self) as? HomeProduct
                                if homeProduct != nil {
                                    DispatchQueue.main.async {
                                        callBack(homeProduct!,nil)
                                    }
                                }else{
                                    callBack(nil,nil)
                                }
                            }else{
                                callBack(nil,nil)
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
    
    
}
