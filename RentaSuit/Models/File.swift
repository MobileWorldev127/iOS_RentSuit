//
//  File.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 11/15/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation

struct NotificationsResponse: Codable {
    let code: String
    let msg: String
    let data: NotificationList
}

struct NotificationList: Codable {
    let list: [Notif]?
    
    enum CodingKeys: String, CodingKey {
        case list = "notification_list"
    }
}

struct Notif: Codable {
    let id, forUser, fromUser, rentID: Int
    let title, message, type, response: String
    let status: Int
    let updatedAt, createdAt, timeDuration: String
    let userDetail: FromUserDetail
    
    enum CodingKeys: String, CodingKey {
        case id
        case forUser = "for_user"
        case fromUser = "from_user"
        case rentID = "rent_id"
        case title, message, type, response, status
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case timeDuration = "time_duration"
        case userDetail = "from_user_detail"
    }
    
    static func notifList(_ page : String?, _ sort : String?,callBack:@escaping ([Notif]?, Int?) -> Void) -> Void {
        var params = [String : String]()
        var hasParams = false
        
        if page != nil {
            hasParams = true
            params["page"] = page!
        }
        
        if sort != nil {
            hasParams = true
            params["sort"] = sort!
        }
        
        let request =
            RequestBuilder.buildGetRequest(url: kBaseUrl + "notification_list",
                                           requireAuth: true,
                                           pathParams: nil,
                                           queryParams: hasParams ? params : nil)
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            
            if (err == nil) && (data != nil) {
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(NotificationsResponse.self, from:
                        data!)
                    if model.data.list != nil {
                        DispatchQueue.main.async {
                            callBack(model.data.list!,200)
                        }
                    }else{
                        DispatchQueue.main.async {
                            callBack(nil,200)
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

struct FromUserDetail: Codable {
    let id: Int
    let firstName, lastName, profilePicture, profilePictureCustomSize: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePicture = "profile_picture"
        case profilePictureCustomSize = "profile_picture_custom_size"
    }
}
