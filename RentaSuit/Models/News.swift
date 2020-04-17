//
//  News.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 25/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import Foundation
class News: NSObject ,NSCoding,MABMapper{
        
        
        @objc var id : Int = 0
        @objc var userId : String?
        @objc var title : String?
        @objc var descriptionNews : String?
        @objc var picture : String?
        @objc var pictureCustomSize : String?
        @objc var seoUrl : String?
   
    
        
        class func map() -> Dictionary<String, Any> {
            return [
                "id" : [
                    "class" : NSNumber.self,
                    "path" : "id",
                    "required" : true,
                    "array" : false
                ],
                "userId" : [
                    "class" : NSString.self,
                    "path" : "user_id",
                    "required" : false,
                    "array" : false
                ],
                "title" : [
                    "class" : NSString.self,
                    "path" : "title",
                    "required" : false,
                    "array" : false
                ],
                "descriptionNews" : [
                    "class" : NSString.self,
                    "path" : "description",
                    "required" : false,
                    "array" : false
                ],
                "picture" : [
                    "class" : NSString.self,
                    "path" : "picture",
                    "required" : false,
                    "array" : false
                ],
                "seoUrl" : [
                    "class" : NSString.self,
                    "path" : "seo_url",
                    "required" : false,
                    "array" : false
                ],
                "pictureCustomSize" : [
                    "class" : NSString.self,
                    "path" : "picture_custom_size",
                    "required" : false,
                    "array" : false
                ]
            ]
        }
    
    

        override init() {
        }
        
        required public init?(coder aDecoder: NSCoder) {
            self.id = aDecoder.decodeInteger(forKey: "id")
            self.userId = (aDecoder.decodeObject(forKey: "userId") as! String)
            
            self.title = (aDecoder.decodeObject(forKey: "title") as! String)
            self.descriptionNews = (aDecoder.decodeObject(forKey: "descriptionNews") as! String)
            self.picture = (aDecoder.decodeObject(forKey: "picture") as! String)
            self.pictureCustomSize = (aDecoder.decodeObject(forKey: "pictureCustomSize") as! String)
            self.seoUrl = (aDecoder.decodeObject(forKey: "seoUrl") as! String)
        }
        
        public func encode(with aCoder: NSCoder) {
            aCoder.encode(id, forKey: "id")
            aCoder.encode(title, forKey: "title")
            aCoder.encode(descriptionNews, forKey: "descriptionNews")
            aCoder.encode(picture, forKey: "picture")
            aCoder.encode(pictureCustomSize, forKey: "pictureCustomSize")
            aCoder.encode(seoUrl, forKey: "seoUrl")
        }
    
    public class func contactUsWs( credentials : Dictionary <String , NSObject>, callBack:@escaping (Bool?,Error?) -> Void) -> Void {
        let request =
            RequestBuilder.buildPostFormDataRequest(url: kBaseUrl + "contact_us", requireAuth: true, pathParams: nil, queryParams : nil, body: credentials)
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
    
}

