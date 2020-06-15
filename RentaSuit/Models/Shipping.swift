//
//  Shipping.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 19/11/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation

import UIKit

public class Shipping: NSObject, NSCoding, MABMapper{
    
    @objc var name  : String?
    @objc var value : String?
   
    
    
    class func map() -> Dictionary<String, Any>{
        return [
            "name" : [
                "class" : NSString.self,
                "path" : "name",
                "required" : false,
                "array" : false
            ],
            "value" : [
                "class" : NSString.self,
                "path" : "value",
                "required" : false,
                "array" : false
            ]
        ]
    }

    override init() {
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.name = (aDecoder.decodeObject(forKey: "name") as! String)
        self.value = (aDecoder.decodeObject(forKey: "value") as! String)
        
    }
    
    public func encode(with aCoder: NSCoder) {

        aCoder.encode(name, forKey: "name")
        aCoder.encode(value, forKey: "value")
    }
    
    
    public class func postShippingCalculator( credentials : Dictionary <String , NSObject>, callBack:@escaping ([Shipping]?,Error?) -> Void) -> Void {
        let request =
            RequestBuilder.buildPostRequest(url: kBaseUrl + "shipping_calculator", requireAuth: true, pathParams: nil, queryParams : nil, body: credentials)
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
                      let code:String? = result["code"]! as? String
                    if code == "200"  {
                        if result["data"] != nil && result["data"] is Dictionary<String,Any>{
                            let newsData:Dictionary<String,Any>  = result["data"] as! Dictionary<String,Any>;
                            if newsData["shipping_calculator"] != nil && newsData["shipping_calculator"] is NSArray{}

                            
                            let shippingArray = MABMapperFetcher<Any>.fetch(array: newsData["shipping_calculator"] as! Array<Any>, type: Shipping.self)
                            if shippingArray != nil && shippingArray is [Shipping] {
                                DispatchQueue.main.async {
                                    callBack((shippingArray! as! [Shipping]),nil)
                                }
                            }else{
                                callBack([],nil)
                            }
                        }else{
                            callBack([],nil)
                        }
                    }else{
                        DispatchQueue.main.async {
                            if result["msg"] is NSDictionary && result["msg"] != nil && result["data"] is NSNull{
                                let errorTemp = NSError(domain:"wrongData", code:101, userInfo:result["msg"]!  as? [String : Any])
                                callBack([],errorTemp)
                                
                            }else if result["msg"] is NSString && result["msg"] != nil {
                                let errorTemp = NSError(domain:result["msg"]! as! String, code:101, userInfo:nil)
                                callBack([],errorTemp)
                            }else{
                                callBack([],error)
                                
                            }
                        }
                    }
                  
                   
                } catch {
                    DispatchQueue.main.async {
                        callBack([],error)
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
                    callBack([],sessionError)
                }
            }
            }.resume()
    }
}
