//
//  RentedProductDetail.swift
//  RentaSuit
//
//  Created by macos on 6/13/20.
//  Copyright © 2020 MacBook Pro. All rights reserved.
//

import Foundation

class RentedProductDetail : RentedProduct{
    @objc var userid : String?
    @objc var productId : String?
    @objc var deliveryOption : String?
    @objc var rentalStartDate : String?
    @objc var rentalEndDate : String?
    @objc var streetNumber : String?
    @objc var route : String?
    @objc var address2 : String?
    @objc var address3 : String?
    @objc var city : String?
    @objc var state : String?
    @objc var postalCode : String?
    @objc var country : String?
    @objc var rentedcontactNumber : String?
    @objc var email : String?
//    @objc var detail : String?
//    @objc var status : String?
    @objc var payKey : String?
    @objc var cartTotal : String?
    @objc var total : String?
    @objc var userReviewSubmitted : String?
    @objc var rentedProductDetail: RentedProduct?
    
    override class func map() -> Dictionary<String, Any>{
        var superMap = super.map()
        superMap["userid"] = [
            "class" : NSString.self,
            "path" : "user_id",
            "required" : false,
            "array" : false
        ]
        superMap["productId"] = [
            "class" : NSString.self,
            "path" : "product_id",
            "required" : false,
            "array" : false
        ]
        superMap["deliveryOption"] = [
            "class" : NSString.self,
            "path" : "delivery_option",
            "required" : false,
            "array" : false
        ]
        superMap["rentalStartDate"] = [
            "class" : NSString.self,
            "path" : "rental_start_date",
            "required" : false,
            "array" : false
        ]
        superMap["rentalEndDate"] = [
            "class" : NSString.self,
            "path" : "rental_end_date",
            "required" : false,
            "array" : false
        ]
        superMap["streetNumber"] = [
            "class" : NSString.self,
            "path" : "street_number",
            "required" : false,
            "array" : false
        ]
        superMap["route"] = [
            "class" : NSString.self,
            "path" : "route",
            "required" : false,
            "array" : false
        ]
        superMap["address2"] = [
            "class" : NSString.self,
            "path" : "address2",
            "required" : false,
            "array" : false
        ]
        superMap["address3"] = [
            "class" : NSString.self,
            "path" : "address3",
            "required" : false,
            "array" : false
        ]
        superMap["city"] = [
            "class" : NSString.self,
            "path" : "city",
            "required" : false,
            "array" : false
        ]
        superMap["state"] = [
            "class" : NSString.self,
            "path" : "state",
            "required" : false,
            "array" : false
        ]
        superMap["postalCode"] = [
            "class" : NSString.self,
            "path" : "postal_code",
            "required" : false,
            "array" : false
        ]
        superMap["country"] = [
            "class" : NSString.self,
            "path" : "country",
            "required" : false,
            "array" : false
        ]
        superMap["rentedcontactNumber"] = [
            "class" : NSString.self,
            "path" : "contact_number",
            "required" : false,
            "array" : false
        ]
        
        superMap["email"] = [
            "class" : NSString.self,
            "path" : "email",
            "required" : false,
            "array" : false
        ]
        
        superMap["detail"] = [
            "class" : NSString.self,
            "path" : "description",
            "required" : false,
            "array" : false
        ]
        
        superMap["status"] = [
            "class" : NSString.self,
            "path" : "status",
            "required" : false,
            "array" : false
        ]
        superMap["payKey"] = [
            "class" : NSString.self,
            "path" : "pay_key",
            "required" : false,
            "array" : false
        ]
        superMap["cartTotal"] = [
            "class" : NSString.self,
            "path" : "cart_total",
            "required" : false,
            "array" : false
        ]
        superMap["total"] = [
            "class" : NSString.self,
            "path" : "total",
            "required" : false,
            "array" : false
        ]
        superMap["userReviewSubmitted"] = [
            "class" : NSString.self,
            "path" : "user_review_submitted",
            "required" : false,
            "array" : false
        ]
        superMap["rentedProductDetail"] = [
            "class" : RentedProduct.self,
            "path" : "product_detail",
            "required" : false,
            "array" : false
        ]

        return superMap
    }
  
  
  class func getRentedProductItemDetails(_ id : String,callBack:@escaping (RentedProductDetail?,Int?) -> Void) -> Void {
      
      let request =
          RequestBuilder.buildGetRequest(url: kBaseUrl + "rented-detail", requireAuth: true, pathParams: nil, queryParams: ["rented_id" : id])
      
      URLSession.shared.dataTask(with: request) { (data, response, err) in
          
          if (err == nil) && (data != nil) {
              let httpResponse = response as! HTTPURLResponse
              do {
                  let result = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String,Any>
                  
                  
                  guard let data = result["data"] as? Dictionary<String,Any> else {
                      DispatchQueue.main.async {
                          callBack(nil,200)
                      }
                      return
                  }
                  guard let object = data["rented_product_detail"] as? Dictionary<String,Any> else {
                      DispatchQueue.main.async {
                          callBack(nil,200)
                      }
                      return
                  }
                  
                  let item = MABMapperFetcher<Any>.fetch(dictionary: object, type: RentedProductDetail.self) as! RentedProductDetail?
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
  
}
