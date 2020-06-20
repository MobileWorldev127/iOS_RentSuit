//
//  AddedProduct.swift
//  RentaSuit
//
//  Created by macos on 6/15/20.
//  Copyright © 2020 MacBook Pro. All rights reserved.
//

import Foundation

struct AddedProductResponse: Codable {
    let status: Int?
    let message: String?
    let data: AddedProductListWrapper?
    
    struct AddedProductListWrapper: Codable{
        var my_products: [AddedProduct]?
        var total: Int?
        var showing: Int?
        var current_time: String?
    }
}

struct AddedProduct: Codable {
    let id, price, rating: Int
    let name: String
    let picture, designer: String
  
    enum CodingKeys: String, CodingKey {
        case id, name, price, picture, designer, rating
    }
  
    static func myAddedProductList(callBack:@escaping ([AddedProduct]?, Int?) -> Void) -> Void {
        let params = [
          "page" : "1",
          "results_per_page": "50",
          "sort": "date-recently"
      ]
        let request =
            RequestBuilder.buildGetRequest(url: kBaseUrl + "my-added-products", requireAuth: true, pathParams: nil, queryParams: params)
      
        URLSession.shared.dataTask(with: request) { (data, response, err) in

            if (err == nil) && (data != nil) {
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(AddedProductResponse.self, from:
                        data!)
                    if model.data != nil {
                        if model.data!.my_products != nil {
                            DispatchQueue.main.async {
                              callBack(model.data!.my_products!, 200)
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

  static func removeAddedProduct(_ id : String, callBack:@escaping (String?) -> Void) -> Void {
    let params = ["product_id" : id]
    let request =
      RequestBuilder.buildDeleteRequest(url: kBaseUrl + "product/remove", requireAuth: true, pathParams: nil, queryParams: params)
    
      URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?,error: Error?) in
        if (error == nil) && (data != nil) {
            do {
                let result = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String,Any>
                guard let code = result["status"] as? String else {
                    DispatchQueue.main.async {
                        callBack("200")
                    }
                    return
                }
                DispatchQueue.main.async {
                    callBack(code)
                }
            } catch {
                DispatchQueue.main.async {
                    callBack("200")
                }
            }
        }else{
            DispatchQueue.main.async {
                callBack("200")
            }
        }
      }.resume()
  }
}
