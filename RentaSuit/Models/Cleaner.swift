//
//  Cleaner.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 11/6/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation

struct CleanersResponse : Codable{
    
    struct CleanersWrapper: Codable{
        var clearner_list: [Cleaner]?
    }
    
    var msg: String?
    var code: String?
    var data: CleanersWrapper?
    
}


struct Cleaner : Codable{
    
    var id: Int
    
    var name: String?
    var shopName: String?
    
    var location : String?
    var latitude: String?
    var longitude: String?
    
    var mobileNumber: String?
    var createdAt : String?
    var updatedAt : String?
    
    enum CodingKeys: String, CodingKey {
        case id
        
        case name
        case shopName = "shop_name"
        
        case location
        case latitude
        case longitude
        
        case mobileNumber = "mobile_number"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    
    static func cleanersAroundMe(callBack:@escaping ([Cleaner]?, Int?) -> Void) -> Void {
        let request =
            RequestBuilder.buildGetRequest(url: kBaseUrl + "cleaner_list", requireAuth: true, pathParams: nil, queryParams: nil)
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            
            if (err == nil) && (data != nil) {
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(CleanersResponse.self, from:
                        data!)
                    if model.data != nil {
                        if model.data!.clearner_list != nil {
                            DispatchQueue.main.async {
                                callBack(model.data!.clearner_list!,200)
                            }
                        }else{
                            DispatchQueue.main.async {
                                callBack(nil,200)
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            callBack(nil,426)
                        }
                    }
                    
                } catch let err {
                    print(err)
                    DispatchQueue.main.async {
                        callBack(nil,426)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    callBack(nil,500)
                }
            }
            
            }.resume()
    }
}
