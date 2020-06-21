//
//  Checkout.swift
//  RentaSuit
//
//  Created by macos on 6/10/20.
//  Copyright © 2020 MacBook Pro. All rights reserved.
//

import Foundation

struct CheckoutResponse: Codable {
    let status: Int?
    let message: String?
    let data: Checkout?
}
struct PaymentStatusResponse: Codable {
    let status: Int?
    let message: String?
    let data: PaymentStatus?
}

struct Checkout: Codable {
    let paymentKey, paymentUrl: String
    
    enum CodingKeys: String, CodingKey {
        case paymentKey = "payment_key"
        case paymentUrl = "payment_url"
    }
    
    static func generatePaymentURL(callBack:@escaping (Checkout?, Int?) -> Void) -> Void {
        let request =
            RequestBuilder.buildPostFormDataRequest(url: kBaseUrl + "checkout/generate-payment-url", requireAuth: true, pathParams: nil, queryParams: nil, body: nil)
      
        URLSession.shared.dataTask(with: request) { (data, response, err) in

            if (err == nil) && (data != nil) {
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(CheckoutResponse.self, from:
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
  
}

struct PaymentStatus: Codable {
    let payKey: String?
     
     enum CodingKeys: String, CodingKey {
         case payKey = "pay_key"
     }
    static func paymentStatus(params : Dictionary <String , NSObject>, callBack:@escaping (PaymentStatus?) -> Void) -> Void {
        let request =
            RequestBuilder.buildPostFormDataRequest(url: kBaseUrl + "checkout/payment-status", requireAuth: true, pathParams: nil, queryParams: nil, body: params)
      
        URLSession.shared.dataTask(with: request) { (data, response, err) in

            if (err == nil) && (data != nil) {
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(PaymentStatusResponse.self, from:
                        data!)
                  if model.data?.payKey != nil {
                        DispatchQueue.main.async {
                          callBack(model.data)
                        }
                    }else{
                        DispatchQueue.main.async {
                            callBack(nil)
                        }
                    }

                } catch let err {
                    print(err)
                    DispatchQueue.main.async {
                        callBack(nil)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    callBack(nil)
                }
            }

            }.resume()
    }
}

struct ProceedToPayment: Codable {
//    let payKey: String?
//     
//     enum CodingKeys: String, CodingKey {
//         case payKey = "pay_key"
//     }
    static func ProceedToPayment(params : Dictionary <String , NSObject>, callBack:@escaping (String?) -> Void) -> Void {
        let request =
            RequestBuilder.buildPostFormDataRequest(url: kBaseUrl + "proceed-to-payment", requireAuth: true, pathParams: nil, queryParams: nil, body: params)
      
        URLSession.shared.dataTask(with: request) { (data, response, err) in

            if (err == nil) && (data != nil) {
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(PaymentStatusResponse.self, from:
                        data!)
                    if model.data != nil {
                        DispatchQueue.main.async {
                          callBack("200")
                        }
                    }else{
                        DispatchQueue.main.async {
                            callBack(nil)
                        }
                    }

                } catch let err {
                    print(err)
                    DispatchQueue.main.async {
                        callBack(nil)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    callBack(nil)
                }
            }

            }.resume()
    }
}
