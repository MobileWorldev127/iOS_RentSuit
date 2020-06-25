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
                "path" : "service",
                "required" : false,
                "array" : false
            ],
            "value" : [
                "class" : NSString.self,
                "path" : "cost",
                "required" : false,
                "array" : false
            ]
        ]
    }

    override init() {
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.name = (aDecoder.decodeObject(forKey: "service") as! String)
        self.value = (aDecoder.decodeObject(forKey: "cost") as! String)
        
    }
    
    public func encode(with aCoder: NSCoder) {

        aCoder.encode(name, forKey: "service")
        aCoder.encode(value, forKey: "cost")
    }
  
    public class func getShippingCalculator( credentials : Dictionary <String , NSObject>, callBack:@escaping ([Shipping]?,Error?) -> Void) -> Void {
        let request =
          RequestBuilder.buildGetRequest(url: kBaseUrl + "shipping-calculator", requireAuth: true, pathParams: nil, queryParams : credentials as! Dictionary<String, String>)
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
                    let code:Int  = result["status"] as! Int
                                             
                    if code  == 200 {
                        if result["data"] != nil && result["data"] is Dictionary<String,Any>{
                            let newsData:Dictionary<String,Any>  = result["data"] as! Dictionary<String,Any>;
                            if newsData["shipping_plans"] != nil && newsData["shipping_plans"] is NSArray{}

                            
                            let shippingArray = MABMapperFetcher<Any>.fetch(array: newsData["shipping_plans"] as! Array<Any>, type: Shipping.self)
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
                            if result["message"] is NSDictionary && result["message"] != nil && result["data"] is NSNull{
                                let errorTemp = NSError(domain:"wrongData", code:101, userInfo:result["message"]!  as? [String : Any])
                                callBack([],errorTemp)
                                
                            }else if result["message"] is NSString && result["message"] != nil {
                                let errorTemp = NSError(domain:result["message"]! as! String, code:101, userInfo:nil)
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
