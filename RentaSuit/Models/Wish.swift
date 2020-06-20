//
//  Wish.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/30/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation

class Wish : Product {
    
    @objc var color : String?
    @objc var detail : String?
    @objc var size : String?
    @objc var season : String?
    @objc var location : String? {
        get{
            return userDetail?.location
        }
    }
    var category : Int {
        get{
            return (userDetail?.bodyType)!
        }
    }
    @objc var seoUrl : String?
    @objc var retailPrice : String?
    @objc var alteration : String?
    @objc var condition : String?
    @objc var designer : String?
    @objc var cancelation : String?
    @objc var cleansingPrice : String?
    @objc var isDeleted : Bool = false
    @objc var createdAt : String?
    @objc var updatedAt : String?
    
    @objc var suggestions : [Product]? //product_suggestions
    @objc var images : [Picture]?
    
    
    @objc var rentStartAt : String?
    @objc var rentEndAt : String?
    
    @objc var owner : String? {
      get{
          return (userDetail?.displayName())!
      }
    }
    
    override class func map() -> Dictionary<String, Any>{
        var superMap = super.map()
        superMap["color"] = [
            "class" : NSString.self,
            "path" : "color",
            "required" : false,
            "array" : false
        ]
        superMap["detail"] = [
            "class" : NSString.self,
            "path" : "description",
            "required" : false,
            "array" : false
        ]
        superMap["size"] = [
            "class" : NSString.self,
            "path" : "size",
            "required" : false,
            "array" : false
        ]
        superMap["season"] = [
            "class" : NSString.self,
            "path" : "season",
            "required" : false,
            "array" : false
        ]
        superMap["seoUrl"] = [
            "class" : NSString.self,
            "path" : "seo_url",
            "required" : false,
            "array" : false
        ]
        superMap["retailPrice"] = [
            "class" : NSString.self,
            "path" : "retail_price",
            "required" : false,
            "array" : false
        ]
        superMap["alteration"] = [
            "class" : NSString.self,
            "path" : "alteration",
            "required" : false,
            "array" : false
        ]
        superMap["condition"] = [
            "class" : NSString.self,
            "path" : "condition",
            "required" : false,
            "array" : false
        ]
        superMap["designer"] = [
            "class" : NSString.self,
            "path" : "designer",
            "required" : false,
            "array" : false
        ]
        superMap["cancelation"] = [
            "class" : NSNumber.self,
            "path" : "cancelation",
            "required" : false,
            "array" : false
        ]
        superMap["cleansingPrice"] = [
            "class" : NSString.self,
            "path" : "cleaning_price",
            "required" : false,
            "array" : false
        ]
        superMap["isDeleted"] = [
            "class" : NSString.self,
            "path" : "is_deleted",
            "required" : false,
            "array" : false
        ]
        superMap["createdAt"] = [
            "class" : NSString.self,
            "path" : "created_at",
            "required" : false,
            "array" : false
        ]
        superMap["updatedAt"] = [
            "class" : NSString.self,
            "path" : "updated_at",
            "required" : false,
            "array" : false
        ]
        
        superMap["suggestions"] = [
            "class" : User.self,
            "path" : "product_suggestions",
            "required" : false,
            "array" : true
        ]
        
        superMap["images"] = [
            "class" : Picture.self,
            "path" : "product_photos",
            "required" : false,
            "array" : true
        ]
        
        superMap["rentStartAt"] = [
            "class" : NSString.self,
            "path" : "disabled_rental_start_date",
            "required" : false,
            "array" : false
        ]
        superMap["rentEndAt"] = [
            "class" : NSString.self,
            "path" : "disabled_rental_end_date",
            "required" : false,
            "array" : false
        ]

        return superMap
    }
    
    class func myWishList(callBack:@escaping ([Wish]?,Int?) -> Void) -> Void {
        var params : Dictionary<String , String> = [:]
        params["page"] = "1" as! String
        params["results_per_page"] = "50" as! String
        let request =
          RequestBuilder.buildGetRequest(url: kBaseUrl + "wish-list", requireAuth: true, pathParams: nil, queryParams : params)
      
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            
            if (err == nil) && (data != nil) {
                let httpResponse = response as! HTTPURLResponse
                do {
                    let result = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String,Any>

                    guard let data = result["data"] as? Dictionary<String,Any> else {
                        DispatchQueue.main.async {
                            callBack(nil,426)
                        }
                        return
                    }
                    guard let array = data["wishlist"] as? Array<Any> else { 
                        DispatchQueue.main.async {
                            callBack(nil,426)
                        }
                        return
                    }
                    
                    let items = MABMapperFetcher<Any>.fetch(array: array, type: Wish.self) as! [Wish]?
                    if items != nil {
                        DispatchQueue.main.async {
                            callBack(items,httpResponse.statusCode)
                        }
                    }else{
                        DispatchQueue.main.async {
                            callBack(nil,httpResponse.statusCode)
                        }
                    }
                    
                } catch let err {
                    print(err)
                    DispatchQueue.main.async {
                        callBack(nil,httpResponse.statusCode)
                    }
                }
            }else{
                callBack(nil,500)
            }
            
            }.resume()
    }
    
    class func getItemDetails(_ id : String,callBack:@escaping (Wish?,Int?) -> Void) -> Void {
        
        let request =
            RequestBuilder.buildGetRequest(url: kBaseUrl + "product-detail", requireAuth: true, pathParams: nil, queryParams: ["product_id" : id])
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            
            if (err == nil) && (data != nil) {
                let httpResponse = response as! HTTPURLResponse
                do {
                    let result = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String,Any>
                    
                    
                    guard let data = result["data"] as? Dictionary<String,Any> else {
                        DispatchQueue.main.async {
                            callBack(nil,426)
                        }
                        return
                    }
                    guard let object = data["product_detail"] as? Dictionary<String,Any> else {
                        DispatchQueue.main.async {
                            callBack(nil,426)
                        }
                        return
                    }
                    
                    let item = MABMapperFetcher<Any>.fetch(dictionary: object, type: Wish.self) as! Wish?
                    if item != nil {
                        DispatchQueue.main.async {
                            callBack(item,httpResponse.statusCode)
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
                callBack(nil,500)
            }
            
            }.resume()
    }
    
    
    func delete(callBack:@escaping (String?) -> Void) -> Void {
        let params = ["product_id" : self.id!]
        let request =
        RequestBuilder.buildDeleteRequest(url: kBaseUrl + "product-remove-wishlist", requireAuth: true, pathParams: nil, queryParams : params)
        URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?,error: Error?) in
            if (error == nil) && (data != nil) {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String,Any>
                    guard let code = result["status"] as? String else {
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
    
    func add(callBack:@escaping (String?) -> Void) -> Void {
        let params = ["product_id" : self.id!,
                      "on_wishlist" : "1"]
        let request =
            RequestBuilder.buildPostFormDataRequest(url: kBaseUrl + "product_add_remove_wishlist", requireAuth: false, pathParams: nil, queryParams : nil, body: params as! Dictionary<String, NSObject>)
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


class Picture: NSObject, MABMapper{
    
    
    @objc var id : String?
    @objc var picture : String?
    @objc var type :  String?
    @objc var price : String?
    @objc var createdAt : String?
    @objc var updatedAt : String?

    
    class func map() -> Dictionary<String, Any>{
        return [
            "id" : [
                "class" : NSString.self,
                "path" : "id",
                "required" : true,
                "array" : false
            ],
            "picture" : [
                "class" : NSString.self,
                "path" : "sub_photo",
                "required" : false,
                "array" : false
            ],
            "type" : [
                "class" : NSString.self,
                "path" : "type",
                "required" : false,
                "array" : false
            ],
            "createdAt" : [
                "class" : NSString.self,
                "path" : "created_at",
                "required" : false,
                "array" : false
            ],
            "updatedAt" : [
                "class" : NSString.self,
                "path" : "updated_at",
                "required" : false,
                "array" : false
            ]
        ]
    }
}
