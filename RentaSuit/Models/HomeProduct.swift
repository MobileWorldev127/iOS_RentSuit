//
//  HomeProduct.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 19/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class HomeProduct: NSObject , NSCoding, MABMapper{
    class func map() -> Dictionary<String, Any>{
        return [
            "listProducts" : [
                "class" : Product.self,
                "path" : "product_list",
                "required" : false,
                "array" : true
            ],
            "totalProduct" : [
                "class" : NSNumber.self,
                "path" : "total_product",
                "required" : false,
                "array" : false
            ],
            "currentTime" : [
                "class" : NSString.self,
                "path" : "current_time",
                "required" : false,
                "array" : false
            ]
        ]
    }
    
    @objc var listProducts:[Product]?
    @objc var totalProduct : Int = 0
    @objc var currentTime : String?
    @objc var currentPage : Int = 0
    @objc var nbrPage : Int = 0
//          var hasMorePage : Bool?

    override init() {
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.listProducts = aDecoder.decodeObject(  forKey: "listProducts") as? [Product]
        self.totalProduct = aDecoder.decodeInteger(  forKey: "totalProduct")
        self.currentTime = aDecoder.decodeObject(  forKey: "currentTime") as? String
        self.currentPage = aDecoder.decodeInteger(  forKey: "currentPage")
        self.nbrPage = aDecoder.decodeInteger(  forKey: "nbrPage")


    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(listProducts, forKey: "listProducts")
        aCoder.encode(totalProduct, forKey: "totalProduct")
        aCoder.encode(currentTime, forKey: "currentTime")
        aCoder.encode(currentPage, forKey: "currentPage")
        aCoder.encode(nbrPage, forKey: "nbrPage")


    }
    func hasMorePage(currentpage:Int) -> Bool {
        if currentpage < self.nbrPage {
            return true
        }else{
            return false
        }
    }
    
    public class func getListProducts(productsUrl:String ,page:Int,callBack:@escaping (HomeProduct?,Error?) -> Void) -> Void {
       
        var request =
            RequestBuilder.buildGetRequest(url: kBaseUrl + productsUrl, requireAuth: false, pathParams: nil, queryParams : nil)
        if page != 0 {
            request.addValue(String(describing: page), forHTTPHeaderField: "page")
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
                                homeProduct?.nbrPage = (homeProduct?.totalProduct)!/10
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
