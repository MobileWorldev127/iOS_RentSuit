//
//  PagerNews.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 25/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
class PagerNews: NSObject  ,NSCoding,MABMapper{
    
    
    @objc var currentPage : Int = 0
    @objc var listNews : [News]?
    @objc var from : Int = 0
    @objc var lastPage : Int = 0
    @objc var nextPageUrl : String?
    @objc var path : String?
    @objc var perPage : Int = 0
    @objc var prevPageUrl : String?
    @objc var to : Int = 0
    @objc var total : Int = 0

    class func map() -> Dictionary<String, Any> {
        return [
            "currentPage" : [
                "class" : NSNumber.self,
                "path" : "current_page",
                "required" : true,
                "array" : false
            ],
            "listNews" : [
                "class" : News.self,
                "path" : "data",
                "required" : false,
                "array" : true
            ],
            "from" : [
                "class" : NSNumber.self,
                "path" : "from",
                "required" : false,
                "array" : false
            ],
            "lastPage" : [
                "class" : NSNumber.self,
                "path" : "lastPage",
                "required" : false,
                "array" : false
            ],
            "nextPageUrl" : [
                "class" : NSString.self,
                "path" : "next_page_url",
                "required" : false,
                "array" : false
            ],
            "path" : [
                "class" : NSString.self,
                "path" : "path",
                "required" : false,
                "array" : false
            ],
            "perPage" : [
                "class" : NSNumber.self,
                "path" : "per_page",
                "required" : false,
                "array" : false
            ],"prevPageUrl" : [
                "class" : NSString.self,
                "path" : "prev_page_url",
                "required" : false,
                "array" : false
            ],
              "to" : [
                "class" : NSNumber.self,
                "path" : "to",
                "required" : false,
                "array" : false
            ]
              ,"total" : [
                "class" : NSNumber.self,
                "path" : "total",
                "required" : false,
                "array" : false
            ]
        ]
    }
    
    
    
    override init() {
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.currentPage = aDecoder.decodeInteger(forKey: "currentPage")
        self.listNews = (aDecoder.decodeObject(forKey: "listNews") as! [News])
        
        self.from = aDecoder.decodeInteger(forKey: "from")
        self.lastPage = aDecoder.decodeInteger(forKey: "lastPage")
        self.nextPageUrl = (aDecoder.decodeObject(forKey: "nextPageUrl") as! String)
        self.path = (aDecoder.decodeObject(forKey: "path") as! String)
        self.prevPageUrl = (aDecoder.decodeObject(forKey: "prevPageUrl") as! String)
        self.perPage = aDecoder.decodeInteger(forKey: "perPage")
        self.to = aDecoder.decodeInteger(forKey: "to")
        self.total = aDecoder.decodeInteger(forKey: "total")

       
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(currentPage, forKey: "currentPage")
        aCoder.encode(listNews, forKey: "listNews")
        aCoder.encode(from, forKey: "from")
        aCoder.encode(lastPage, forKey: "lastPage")
        aCoder.encode(nextPageUrl, forKey: "nextPageUrl")
        aCoder.encode(path, forKey: "path")
        aCoder.encode(perPage, forKey: "perPage")
        aCoder.encode(prevPageUrl, forKey: "prevPageUrl")
        aCoder.encode(total, forKey: "total")
        aCoder.encode(to, forKey: "to")

    }
    
    public class func getListNews(newsUrl:String,paginated:Bool,callBack:@escaping (PagerNews?,Error?) -> Void) -> Void {
        
        var urlString = kBaseUrl + newsUrl
        if paginated {
            urlString = newsUrl 
        }
        
        let request =
            RequestBuilder.buildGetRequest(url: urlString , requireAuth: false, pathParams: nil, queryParams : nil)
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
                                let newsData:Dictionary<String,Any>  = result["data"] as! Dictionary<String,Any>;
                                
                                let pagerNews = MABMapperFetcher<Any>.fetch(dictionary: newsData, type: PagerNews.self) as? PagerNews
                                if pagerNews != nil {
                                    DispatchQueue.main.async {
                                        callBack(pagerNews!,nil)
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

