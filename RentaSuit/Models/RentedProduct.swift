
//
//  RentedProduct.swift
//  RentaSuit
//
//  Created by macos on 6/11/20.
//  Copyright © 2020 MacBook Pro. All rights reserved.
//

import Foundation

class RentedProduct : Product{
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
    @objc var status: String?
    
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
        superMap["status"] = [
            "class" : NSString.self,
            "path" : "status",
            "required" : false,
            "array" : false
        ]

        return superMap
    }
  
  class func myRentedList(callBack:@escaping ([RentedProduct]?,Int?) -> Void) -> Void {
      var params : Dictionary<String , String> = [:]
      params["page"] = "1" as! String
      params["results_per_page"] = "50" as! String
      let request =
        RequestBuilder.buildGetRequest(url: kBaseUrl + "rented-list", requireAuth: true, pathParams: nil, queryParams : params)
    
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
                  guard let array = data["rented_list"] as? Array<Any> else {
                      DispatchQueue.main.async {
                          callBack(nil,426)
                      }
                      return
                  }
                  
                  let items = MABMapperFetcher<Any>.fetch(array: array, type: RentedProduct.self) as! [RentedProduct]?
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
}
