//
//  AddedProduct.swift
//  RentaSuit
//
//  Created by macos on 6/15/20.
//  Copyright © 2020 MacBook Pro. All rights reserved.
//

import Foundation

struct BookingResponse: Codable {
    let status: Int?
    let message: String?
    let data: BookingWrapper?
    
    struct BookingWrapper: Codable{
        var booking_list: [Booking]?
    }
}

struct OwnerDetail: Codable {
  var id, firstName, lastName, email, picture, location: String
  
  enum CodingKeys: String, CodingKey {
      case id, email, location
      case firstName = "first_name"
      case lastName = "last_name"
      case picture = "profile_picture"
  }
}

struct Booking: Codable {
    
    let id, userId, productId, cartTotal, total, userReviewSubmitted: Int
    let deliveryOption, rentalStartDate, rentalEndDate, streetNumber, route, address2, address3, city, state, postalCode, country, contactNumber, email, detail, status, payKey : String
    let userDetail: OwnerDetail?
  
    enum CodingKeys: String, CodingKey {
        case id, route, address2, address3, city, state, country, email, status, total
        case userId = "user_id"
        case productId = "product_id"
        case deliveryOption = "delivery_option"
        case rentalStartDate = "rental_start_date"
        case rentalEndDate = "rental_end_date"
        case streetNumber = "street_number"
        case postalCode = "postal_code"
        case contactNumber = "contact_number"
        case detail = "description"
        case payKey = "pay_key"
        case cartTotal = "cart_total"
        case userReviewSubmitted = "user_review_submitted"
        case userDetail = "added_by"
    }
  
    static func myBookingList(_ id : String, callBack:@escaping ([Booking]?, Int?) -> Void) -> Void {
        let params = [ "product_id" : id ]
        let request =
            RequestBuilder.buildGetRequest(url: kBaseUrl + "booking-list", requireAuth: true, pathParams: nil, queryParams: params)
      
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            if (err == nil) && (data != nil) {
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(BookingResponse.self, from:
                        data!)
                    if model.data != nil {
                        if model.data!.booking_list != nil {
                            DispatchQueue.main.async {
                              callBack(model.data!.booking_list!, 200)
                            }
                        } else {
                          DispatchQueue.main.async {
                              callBack(nil,200)
                          }
                        }
                    } else{
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
