//
//  Cart.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 11/6/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation

struct CartResponse: Codable {
    let status: Int?
    let message: String?
    let data: [Cart]?
}

struct Cart: Codable {
    let id, userID, productID: Int
    let deliveryOption: String
    let returnDeliveryOption, returnDate: JSONNull?
    let rentalStartDate: String
    let shippingInfo, returnShippingInfo: JSONNull?
    let rentalEndDate, streetNumber, route, address2: String
    let address3, city, state, postalCode: String
    let country, contactNumber, email, description: String
    let status: String
    let reason: JSONNull?
    let payKey: String
    let cartTotal, total: Int
    let rating: JSONNull?
    let userReviewSubmitted: Int
    let createdAt, updatedAt: String
    let productDetail: ProductDetail
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case productID = "product_id"
        case deliveryOption = "delivery_option"
        case returnDeliveryOption = "return_delivery_option"
        case returnDate = "return_date"
        case rentalStartDate = "rental_start_date"
        case shippingInfo = "shipping_info"
        case returnShippingInfo = "return_shipping_info"
        case rentalEndDate = "rental_end_date"
        case streetNumber = "street_number"
        case route, address2, address3, city, state
        case postalCode = "postal_code"
        case country
        case contactNumber = "contact_number"
        case email, description, status, reason
        case payKey = "pay_key"
        case cartTotal = "cart_total"
        case total, rating
        case userReviewSubmitted = "user_review_submitted"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case productDetail = "product_detail"
    }
    
    
    static func cartList(callBack:@escaping ([Cart]?, Int?) -> Void) -> Void {
        let request =
            RequestBuilder.buildGetRequest(url: kBaseUrl + "cart/list", requireAuth: true, pathParams: nil, queryParams: nil)
      
        URLSession.shared.dataTask(with: request) { (data, response, err) in

            if (err == nil) && (data != nil) {
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(CartResponse.self, from:
                        data!)
                    if model.data != nil {
                        DispatchQueue.main.async {
                            callBack(model.data!,200)
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
    
    
    func delete(callBack:@escaping (String?) -> Void) -> Void {
        let params = ["product_id" : String(self.productID)]
        let request =
        RequestBuilder.buildDeleteRequest(url: kBaseUrl + "cart/remove", requireAuth: true, pathParams: nil, queryParams : params)
        URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?,error: Error?) in
            if (error == nil) && (data != nil) {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String,Any>
                    guard let code = result["status"] as? String else {
                        DispatchQueue.main.async {
                            callBack("500")
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        callBack(code)
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        callBack("500")
                    }
                }
            }else{
                DispatchQueue.main.async {
                    callBack("500")
                }
            }
            }.resume()
    }
    
    func deleteAll(callBack:@escaping (String?) -> Void) -> Void {
        let request =
            RequestBuilder.buildPostFormDataRequest(url: kBaseUrl + "empty_cart", requireAuth: true, pathParams: nil, queryParams : nil, body:nil)
        URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?,error: Error?) in
            if (error == nil) && (data != nil) {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String,Any>
                    guard let code = result["code"] as? String else {
                        DispatchQueue.main.async {
                            callBack("500")
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        callBack(code)
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        callBack("500")
                    }
                }
            }else{
                DispatchQueue.main.async {
                    callBack("500")
                }
            }
            }.resume()
    }
    
    static func add(params : [String : NSObject], callBack:@escaping (String?) -> Void) -> Void {
        let request =
            RequestBuilder.buildPostFormDataRequest(url: kBaseUrl + "cart/add", requireAuth: true, pathParams: nil, queryParams : nil, body: params)
        URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?,error: Error?) in
            if (error == nil) && (data != nil) {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String,Any>
                    guard let code = result["status"] as? String else {
                        DispatchQueue.main.async {
                            callBack("500")
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        callBack(code)
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        callBack("500")
                    }
                }
            }else{
                DispatchQueue.main.async {
                    callBack("500")
                }
            }
            }.resume()
        
    }
    
    static func createPost(params : [String : NSObject], callBack:@escaping (String?) -> Void) -> Void {
        let request =
            RequestBuilder.buildPostFormDataRequest(url: kBaseUrl + "post_item", requireAuth: true, pathParams: nil, queryParams : nil, body: params)
        URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?,error: Error?) in
            if (error == nil) && (data != nil) {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String,Any>
                    guard let code = result["code"] as? String else {
                        DispatchQueue.main.async {
                            callBack("500")
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        callBack(code)
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        callBack("500")
                    }
                }
            }else{
                DispatchQueue.main.async {
                    callBack("500")
                }
            }
            }.resume()
        
    }
}

struct ProductDetail: Codable {
    let id, userID, price: Int
    let name, picture: String
    let userDetail: UserDetail
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name, price, picture
        case userDetail = "added_by"
    }
}

struct UserDetail: Codable {
    let id: Int
    let firstName, lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

// MARK: Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

