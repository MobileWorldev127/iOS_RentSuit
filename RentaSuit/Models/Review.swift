
import Foundation

class Review : NSObject , NSCoding, MABMapper{

    @objc var id  : String?
    @objc var userId : String?
    @objc var productId : String?
    @objc var rating : String?
    @objc var title : String?
    @objc var comment : String?
    @objc var userDetail : UserProfile?
     
     class func map() -> Dictionary<String, Any>{
         return [
             "id" : [
                 "class" : NSString.self,
                 "path" : "id",
                 "required" : false,
                 "array" : false
             ],
             "userId" : [
                 "class" : NSString.self,
                 "path" : "user_id",
                 "required" : false,
                 "array" : false
             ],
             "productId" : [
                 "class" : NSString.self,
                 "path" : "product_id",
                 "required" : false,
                 "array" : false
             ],
            "rating" : [
                "class" : NSString.self,
                "path" : "rating",
                "required" : false,
                "array" : false
            ],
            "title" : [
                "class" : NSString.self,
                "path" : "title",
                "required" : false,
                "array" : false
            ],
            "comment" : [
                "class" : NSString.self,
                "path" : "comment",
                "required" : false,
                "array" : false
            ],
            "userDetail" : [
                "class" : UserProfile.self,
                "path" : "reviewed_by",
                "required" : false,
                "array" : false
            ]
         ]
     }

     override init() {
     }
     
     required public init?(coder aDecoder: NSCoder) {
         self.id = (aDecoder.decodeObject(forKey: "id") as! String)
         self.userId = (aDecoder.decodeObject(forKey: "userId") as! String)
         self.productId = (aDecoder.decodeObject(forKey: "productId") as! String)
         self.rating = (aDecoder.decodeObject(forKey: "rating") as! String)
         self.title = (aDecoder.decodeObject(forKey: "title") as! String)
         self.comment = (aDecoder.decodeObject(forKey: "comment") as! String)
         self.userDetail = (aDecoder.decodeObject(forKey: "userDetail") as? UserProfile)
     }
     
     public func encode(with aCoder: NSCoder) {
      aCoder.encode(id, forKey: "id")
      aCoder.encode(userId, forKey: "userId")
      aCoder.encode(productId, forKey: "productId")
      aCoder.encode(rating, forKey: "rating")
      aCoder.encode(title, forKey: "title")
      aCoder.encode(comment, forKey: "comment")
      aCoder.encode(userDetail, forKey: "userDetail")
     }
  
  class func myReviewsList(_ id : String, callBack:@escaping ([Review]?,Int?) -> Void) -> Void {
      let request =
        RequestBuilder.buildGetRequest(url: kBaseUrl + "reviews", requireAuth: true, pathParams: nil, queryParams: ["product_id" : id])
    
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
                  guard let array = data["review_list"] as? Array<Any> else {
                      DispatchQueue.main.async {
                          callBack(nil,426)
                      }
                      return
                  }
                  
                  let items = MABMapperFetcher<Any>.fetch(array: array, type: Review.self) as! [Review]?
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
  class func submitReview(params : Dictionary <String , NSObject>,callBack:@escaping (Bool?,Error?) -> Void) -> Void {
      let request =
      RequestBuilder.buildPostFormDataRequest(url: kBaseUrl + "submit-product-review", requireAuth: false, pathParams: nil, queryParams : nil, body: params)
    
      URLSession.shared.dataTask(with: request) { (data, response, err) in
          
          if (err == nil) && (data != nil) {
              let httpResponse = response as! HTTPURLResponse
              do {
                  let result = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String,Any>

                  if result["status"] != nil{
                      let code:Int  = result["status"]! as! Int;
                      
                      if code == 200{
                          DispatchQueue.main.async {
                              callBack(true,nil)
                          }
                      }else{
                          DispatchQueue.main.async {
                              if result["message"] is NSDictionary && result["message"] != nil && result["data"] is NSNull{
                                  let errorTemp = NSError(domain:"", code:101, userInfo:result["message"]!  as? [String : Any])
                                  callBack(nil,errorTemp)
                                  
                              }else if result["message"] is NSString && result["message"] != nil {
                                  let errorTemp = NSError(domain:result["message"]! as! String, code:101, userInfo:nil)
                                  callBack(nil,errorTemp)
                              }else{
                                  callBack(nil,nil)
                                  
                              }
                          }
                      }
                  }
              } catch let err {
                  print(err)
                  DispatchQueue.main.async {
                      callBack(nil, err)
                  }
              }
          }else{
              var sessionError : Error?;
              if err == nil {
                  sessionError = NSError(domain:"NO DATA ERROR", code:-12332, userInfo:nil) as Error
              }else{
                  sessionError = err
              }
              DispatchQueue.main.async {
                  callBack(nil,sessionError)
              }
          }
        }.resume()
  }
  
}
