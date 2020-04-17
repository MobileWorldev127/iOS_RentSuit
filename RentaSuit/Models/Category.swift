//
//  Category.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 11/1/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation


struct CategoriesResponse : Codable{
    
    struct CategoriesWrapper: Codable{
        var category_list: [Category]?
    }
    
    var msg: String?
    var code: String?
    var data: CategoriesWrapper?
   
}

struct Category: Codable{
    
    var id: Int
    var name: String?

    
    static private var _current : [Category]?
    
    static func cached() -> [Category]? {
        if _current != nil {
            return _current
        }
        let decoded  = UserDefaults(suiteName: "group.rentaSuit")!.value(forKey: "categories") as? Data
        if decoded == nil{
            return nil
        }
        _current = try? PropertyListDecoder().decode([Category].self, from: decoded!)
        return _current
    }
    
    static func categoryWithId(_ id : Int) -> String?{
        if Category.cached() != nil {
            let cached = Category.cached()
            let result = cached?.first(where: { (category) -> Bool in
                category.id == id
            })
            
            if result != nil {
                return result?.name
            }
            return nil
        }
        return nil
    }
    
    static func store ( categories : [Category]) {
        UserDefaults(suiteName: "group.rentaSuit")!
            .set(try? PropertyListEncoder().encode(categories), forKey: "categories")
        UserDefaults(suiteName: "group.rentaSuit")!.synchronize()
        _current = categories
    }
    
    static func purge(){
        _current = nil
        UserDefaults(suiteName: "group.rentaSuit")!.removeObject(forKey: "categories")
        UserDefaults(suiteName: "group.rentaSuit")!.synchronize()
    }

    public static func loadRemoteCategories(){
        let request =
            RequestBuilder.buildGetRequest(url: kBaseUrl + "category_list", requireAuth: true, pathParams: nil, queryParams: nil)
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            
            if (err == nil) && (data != nil) {
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(CategoriesResponse.self, from:
                        data!)
                    if model.data != nil {
                        if model.data!.category_list != nil {
                            Category.purge()
                            Category.store(categories: model.data!.category_list!)
                            print("success")
                        }
                    }
                    
                } catch {
                    print("Error")
                }
            }
            
            }.resume()
    }
    
}
