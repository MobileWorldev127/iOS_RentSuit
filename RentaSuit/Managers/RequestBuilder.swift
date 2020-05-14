//
//  RequestBuilder.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 07/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit

/*
 HTTPMethods struct
 */

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case update  = "UPDATE"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

open class RequestBuilder {
    
    static let TIMEOUT = 30
    
    /*
     build buildPostRequest
     params :
     url : end point
     requiredAuth : require session token ?
     pathParams : /{param}/
     queryParams : ?key1=value1&key2=value2
     body : request HTTPBody Data
     */
    
    static func buildPostRequest(url : String, requireAuth : Bool, pathParams : [String]?,  queryParams : Dictionary <String , String>? , body : Dictionary <String , Any>?) -> URLRequest {
        
        var urlString = ""
        
        
        // append path params
        if  pathParams != nil {
            urlString = String(format: url, arguments: pathParams!)
        }else{
            urlString = url
        }
        
        // append query parms
        if  queryParams != nil {
            var i = 0
            for (key, element) in queryParams! {
                if i == 0{
                    urlString = urlString.appendingFormat("?%@=%@", key,element)
                }else{
                    urlString = urlString.appendingFormat("&%@=%@", key,element)
                }
                i += 1
            }
        }
        
        var request = URLRequest(url: URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.httpMethod = HTTPMethod.post.rawValue
        
        // add body to request
        if body != nil {
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: body!, options: JSONSerialization.WritingOptions.prettyPrinted)
            }catch{
            }
        }
        
        // add headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        appendAuthorizationToRequest(requireAuth, &request)
        
        return request
    }
    
    /*
     build buildPostRequest formdata
     params :
     url : end point
     requiredAuth : require session token ?
     pathParams : /{param}/
     queryParams : ?key1=value1&key2=value2
     body : request HTTPBody Data
     */
    static func buildPostFormDataRequest(url : String, requireAuth : Bool, pathParams : [String]?,  queryParams : Dictionary <String , String>? , body : Dictionary <String , NSObject>?) -> URLRequest {
        
        var urlString = ""
        
        
        // append path params
        if  pathParams != nil {
            urlString = String(format: url, arguments: pathParams!)
        }else{
            urlString = url
        }
        
        // append query parms
        if  queryParams != nil {
            var i = 0
            for (key, element) in queryParams! {
                if i == 0{
                    urlString = urlString.appendingFormat("?%@=%@", key,element)
                }else{
                    urlString = urlString.appendingFormat("&%@=%@", key,element)
                }
                i += 1
            }
        }
        
        var request = URLRequest(url: URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.httpMethod = HTTPMethod.post.rawValue
        
        // add body to request
        let boundaryConstant = "rent_4_suit_b0und4ry_$$cOn574n7"
        
        if body != nil {
            let uploadData = NSMutableData()
            
            for (_, element) in (body?.enumerated())!{
                if !(element.value is UIImage) {
                    uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                    uploadData.append("Content-Disposition: form-data; name=\"\(element.key)\"\r\n\r\n\(element.value)".data(using: String.Encoding.utf8)!)
                }else{
                    let data = element.value as! UIImage
                    
                    uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                    uploadData.append("Content-Disposition: form-data; name=\"\(element.key)\"; filename=\"\(element.key).jpg\"\r\n".data(using: String.Encoding.utf8)!)
                    uploadData.append("Content-Type: image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
                    uploadData.append(UIImageJPEGRepresentation(data, 0.8)!)
                }
            }
            
            uploadData.append("\r\n--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
            
            request.httpBody = uploadData as Data
        }
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        
        // add headers
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        appendAuthorizationToRequest(requireAuth, &request)
        
        return request
    }
    
    /*
     build buildGetRequest
     params :
     url : end point
     requiredAuth : require session token ?
     pathParams : /{param}/
     queryParams : ?key1=value1&key2=value2
     */
    static func buildGetRequest(url : String, requireAuth : Bool, pathParams : [String]?, queryParams : Dictionary <String , String>?) -> URLRequest {
        var urlString = ""
        
        
        // append query params
        if  pathParams != nil {
            urlString = String(format: url, arguments: pathParams!)
        }else{
            urlString = url
        }
        
        // append query parms
        if  queryParams != nil {
            var i = 0
            for (key, element) in queryParams! {
                if i == 0{
                    urlString = urlString.appendingFormat("?%@=%@", key,element)
                }else{
                    urlString = urlString.appendingFormat("&%@=%@", key,element)
                }
                i += 1
            }
        }
        
        var request = URLRequest(url: URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.httpMethod = HTTPMethod.get.rawValue
        
        
        // add headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        appendAuthorizationToRequest(requireAuth, &request)
        
        return request
    }
    
    /*
     build buildUpdateRequest
     params :
     url : end point
     requiredAuth : require session token ?
     pathParams  /{param}/
     queryParams ?key1=value1&key2=value2
     body : request HTTPBody Data
     */
    static func buildPutRequest(url : String, requireAuth : Bool, pathParams : [String]?, body : Dictionary <String , Any>? ) -> URLRequest {
        
        var urlString = ""
        
        
        // append query params
        if  pathParams != nil {
            urlString = String(format: url, arguments: pathParams!)
        }else{
            urlString = url
        }
        
        
        var request = URLRequest(url: URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.httpMethod = HTTPMethod.put.rawValue
        
        // add body to request
        if body != nil {
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: body!, options: JSONSerialization.WritingOptions.prettyPrinted)
            }catch{
                
            }
        }
        
        // add headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        appendAuthorizationToRequest(requireAuth, &request)
        
        return request
        
    }
    
    /*
     build buildDeleteRequest
     params :
     url : end point
     requiredAuth : require session token ?
     pathParams  /{param}/
     queryParams ?key1=value1&key2=value2
     */
    static func buildDeleteRequest(url : String, requireAuth : Bool, pathParams : [String]?, queryParams : Dictionary <String , String>? ) -> URLRequest {
        var urlString = ""
        
        
        // append query params
        if pathParams != nil {
            urlString = String(format: url, arguments: pathParams!)
        }else{
            urlString = url
        }
        
        // append query parms
        if queryParams != nil {
            var i = 0
            for (key, element) in queryParams! {
                if i == 0{
                    urlString = urlString.appendingFormat("?%@=%@", key,element)
                }else{
                    urlString = urlString.appendingFormat("&%@=%@", key,element)
                }
                i += 1
            }
        }
        
        var request = URLRequest(url: URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        
        // add headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        appendAuthorizationToRequest(requireAuth, &request)
        
        return request
    }
    
    
    /*
     set up auth and timeout params to request
     */
    fileprivate static func appendAuthorizationToRequest(_ requireAuth: Bool, _ request: inout URLRequest) {
        // append session token if require auth
        request.timeoutInterval = TimeInterval(RequestBuilder.TIMEOUT)
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        //        if User.UserIsConnected() {
        if User.isConnected() {
            if (User.current()!.sessionToken != nil){
                request.setValue(User.current()!.bearerToken, forHTTPHeaderField: "Authorization")
            }
        }
    }
    
}









