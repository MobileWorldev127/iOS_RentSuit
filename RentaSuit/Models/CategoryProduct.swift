//
//  CategoryProduct.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 20/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class CategoryProduct: NSObject , NSCoding, MABMapper{
    
    
    @objc var id : String?
    @objc var name : String?
    @objc var picture : String?
    
    
    class func map() -> Dictionary<String, Any>{
        return [
            "id" : [
                "class" : NSString.self,
                "path" : "id",
                "required" : true,
                "array" : false
            ],
            "name" : [
                "class" : NSString.self,
                "path" : "name",
                "required" : false,
                "array" : false
            ],
            "picture" : [
                "class" : NSString.self,
                "path" : "picture",
                "required" : false,
                "array" : false
            ]
        ]
    }
    
    override init() {
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(  forKey: "id") as? String
        self.name = aDecoder.decodeObject(  forKey: "name") as? String
        self.picture = aDecoder.decodeObject(  forKey: "picture") as? String
        
        
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(picture, forKey: "picture")
        
        
    }
    public class func getListCategoriesProducts(callBack:@escaping (Array<CategoryProduct>?,Error?) -> Void) -> Void {
        let request =
            RequestBuilder.buildGetRequest(url: kBaseUrl + "category_list", requireAuth: false, pathParams: nil, queryParams : nil)
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
                                
                                if productsDetails["category_list"] != nil && productsDetails["category_list"] is Array<Any>{
                                    
                                    let categoriesArray: Array<CategoryProduct> = MABMapperFetcher<Any>.fetch(array:productsDetails["category_list"] as! Array<Any> , type: CategoryProduct.self) as! Array<CategoryProduct>
                                        DispatchQueue.main.async {
                                            callBack(categoriesArray,nil)
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
