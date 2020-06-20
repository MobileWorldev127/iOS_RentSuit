//
//  AddedProduct.swift
//  RentaSuit
//
//  Created by macos on 6/15/20.
//  Copyright © 2020 MacBook Pro. All rights reserved.
//

import Foundation

struct AddedProdutDetailResponse: Codable {
    let status: Int?
    let message: String?
    let data: AddedProductDetail?
  
    struct AddedProductDetail: Codable{
      var product_detail: AddedProductDetailItem?
    }
}

struct AddedProductDetailItem: Codable {
    struct CategoryItem: Codable{
        var id, status, shipping_fee_local, shipping_fee_nationwide, product_id, category_id: Int?
        var name, picture, seo_url: String?
    }
  
    let id, userId, price, retailPrice, cleaningPrice, isDeleted: Int
    let name, detail, color, size, season, picture, seoUrl, alteration, condition, designer, cancellation, displaySize: String
    let categories: CategoryItem?
  
    enum CodingKeys: String, CodingKey {
        case id, name, price, color, size, season, picture, alteration, condition, designer, cancellation
        case userId = "user_id"
        case retailPrice = "retail_price"
        case cleaningPrice = "cleaning_price"
        case isDeleted = "is_deleted"
        case detail = "description"
        case seoUrl = "seo_url"
        case displaySize = "display_size"
        case categories = "categories"
    }
  
    static func addedProductDetail(_ id : String, callBack:@escaping (AddedProductDetailItem?, Int?) -> Void) -> Void {
        let request =
        RequestBuilder.buildGetRequest(url: kBaseUrl + "product/" + id, requireAuth: true, pathParams: nil, queryParams: nil)
      
        URLSession.shared.dataTask(with: request) { (data, response, err) in

            if (err == nil) && (data != nil) {
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(AddedProdutDetailResponse.self, from:
                        data!)
                    if model.data != nil {
                        if model.data!.product_detail != nil {
                            DispatchQueue.main.async {
                              callBack(model.data!.product_detail!, 200)
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


struct updateAddedProdutResponse: Codable {
    let status: Int?
    let message: String?
    let data: updateAddedProductDetail?
  
    struct updateAddedProductDetail: Codable{
      var product_detail: UpdateAddedProductDetailItem?
    }
}
struct UpdateAddedProductDetailItem: Codable {
    let id, userId, isDeleted: Int
    let name, detail, price, color, size, season, picture, seoUrl, retailPrice, cleaningPrice, alteration, condition, designer, cancellation: String
  
    enum CodingKeys: String, CodingKey {
        case id, name, price, color, size, season, picture, alteration, condition, designer, cancellation
        case userId = "user_id"
        case retailPrice = "retail_price"
        case cleaningPrice = "cleaning_price"
        case isDeleted = "is_deleted"
        case detail = "description"
        case seoUrl = "seo_url"
    }
    static func updateProduct(params : [String : NSObject], callBack:@escaping (String?) -> Void) -> Void {
        let request =
            RequestBuilder.buildPostFormDataRequest(url: kBaseUrl + "product/update", requireAuth: true, pathParams: nil, queryParams : nil, body: params)
        URLSession.shared.dataTask(with: request) { (data, response, err) in

        if (err == nil) && (data != nil) {
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(updateAddedProdutResponse.self, from:
                    data!)
                if model.data != nil {
                    if model.data!.product_detail != nil {
                        DispatchQueue.main.async {
                          callBack("200")
                        }
                    } else {
                      DispatchQueue.main.async {
                          callBack("401")
                      }
                    }
                } else{
                    DispatchQueue.main.async {
                       callBack("401")
                    }
                }

            } catch let err {
                print(err)
                DispatchQueue.main.async {
                    callBack("401")
                }
            }
        }else{
            DispatchQueue.main.async {
                callBack("401")
            }
        }

        }.resume()
        
    }
}
