//
//  MABMapperFetcher.swift
//  SwiftMABMapper
//
//  Created by Med Amine Ben Salah on 13/10/2017.
//  Copyright © 2017 Anypli. All rights reserved.
//

import UIKit

class MABMapperFetcher<T>: NSObject {
    
    class func fetch(dictionary:Dictionary<String,Any>,type:MABMapper.Type) -> T? {
        let map = type.map();
        let objectType = type as! NSObject.Type
        let object = objectType.init()
        for key in Array(map.keys) {
            let subMap = map[key] as! Dictionary<String,Any>
            let path = subMap["path"] as! String
            let required = subMap["required"] as! Bool
            let isArray = subMap["array"] as! Bool
            let klass = subMap["class"] as! NSObject.Type
            let dateFormat = subMap["dateFormat"] as! String?
            let timeZone = subMap["timeZone"] as! TimeZone?
            //
            //            let html = subMap["html"] as! Bool
            
            
            let pathComponents = path.components(separatedBy: ".")
            
            var currentDict = dictionary as NSObject?
            for component in pathComponents {
                if currentDict is Array<Any> {
                    currentDict = (currentDict as! Array).first!
                }
                if currentDict is NSNull {
                    currentDict = nil;
                    break
                }
                if  !(currentDict is Dictionary<String, Any>) {
                    currentDict = nil;
                    break
                }
                currentDict = (currentDict as! Dictionary<String, Any>)[component] as! NSObject?
            }
            let obj = currentDict;
            //
            if obj == nil {
                if (required) {
                    return nil;
                }else{
                    continue;
                }
            }else{
                var parsedObj: Any?
                if klass == NSString.self {
                    if isArray {
                        parsedObj = self.arrayOfStringsFrom(object: obj)
                    }else{
                        //                        if(html){
                        //                            parsedObj = [self convertHTML:[self stringFromObject:obj]];
                        //                        }else{
                        parsedObj = self.stringFrom(object: obj)
                        //                        }
                    }
                }else if klass == NSNumber.self {
                    if isArray {
                        parsedObj = self.arrayOfNumbersFrom(object:obj)
                    }else{
                        parsedObj = self.numberFrom(object:obj)
                    }
                }else if klass == NSDictionary.self {
                    if isArray {
                        parsedObj = self.arrayOfDictionariesFrom(object:obj)
                    }else{
                        parsedObj = self.dictionaryFrom(object:obj)
                    }
                }else if klass == NSDate.self {
                    if isArray {
                        parsedObj = self.arrayOfDateFrom(object:obj,format:dateFormat,timeZone:timeZone)
                    }else{
                        parsedObj = self.dateFrom(object:obj, format:dateFormat, timeZone:timeZone)
                    }
                }else{
                    if isArray {
                        if obj is Array<Any> {
                            parsedObj = MABMapperFetcher.fetch(array: obj! as! Array<Any>, type: klass as! MABMapper.Type)
                        }else{
                            let obj2 = MABMapperFetcher.fetch(dictionary: obj! as! Dictionary<String, Any>, type: klass as! MABMapper.Type)
                            if obj2 != nil {
                                parsedObj = [obj2];
                            }
                        }
                    }else{
                        if !(obj is NSNull){
                            parsedObj = MABMapperFetcher.fetch(dictionary: obj! as! Dictionary<String, Any>, type: klass as! MABMapper.Type)
                        }
                    }
                }
                if (parsedObj != nil) {
                    object .setValue(parsedObj, forKeyPath: key)
                }else{
                    if (required) {
                        return nil;
                    }
                }
                
            }
            
        }
        
        return (object as! T);
    }
    
    class func fetch(array:Array<Any>,type:MABMapper.Type) -> Array<T>? {
        
        var resultArray : Array<T>?
        for dict in array {
            if dict is  Dictionary<String, Any> {
                let object = MABMapperFetcher<T>.fetch(dictionary:dict as! Dictionary<String, Any>,type:type)
                if object != nil {
                    if resultArray == nil {
                        resultArray = Array<T>()
                    }
                    resultArray!.append(object!)
                }
            }
            
        }
        return resultArray;
    }
    
    // MARK: - Dictionary
    
    class func dictionaryFrom(object:Any?) -> Dictionary<String,Any>? {
        var obj = object;
        if obj is Array<Any> {
            let array = object as! Array<Any>
            if array.count > 0 {
                obj = array.first ;
            }else{
                return nil;
            }
        }
        return self.getDictionaryValueFrom(object: obj)
    }
    
    class func arrayOfDictionariesFrom(object:Any?) -> Array<Dictionary<String,Any>>{
        var resultArray = Array<Dictionary<String,Any>>()
        
        if object is Array<Any> {
            let array = object as! Array<Any>
            if array.count > 0 {
                for subObject in array {
                    let parsedObject = self.getDictionaryValueFrom(object:subObject)
                    if parsedObject != nil{
                        resultArray.append(parsedObject!)
                    }
                    
                }
            }
        }else{
            let parsedObject = self.getDictionaryValueFrom(object:object)
            if parsedObject != nil{
                resultArray.append(parsedObject!)
            }
        }
        
        return resultArray
    }
    
    class func getDictionaryValueFrom(object:Any?) -> Dictionary<String,Any>? {
        if (object == nil) || (object is NSNull) {
            return nil
        }
        
        if object is Dictionary<String,Any> {
            return object as? Dictionary<String,Any>
        }
        
        
        return nil;
    }
    
    
    // MARK: - String
    
    class func stringFrom(object:Any?) -> String? {
        var obj = object;
        if obj is Array<Any> {
            let array = object as! Array<Any>
            if array.count > 0 {
                obj = array.first ;
            }else{
                return nil;
            }
        }
        return self.getStringValueFrom(object: obj)
    }
    
    class func arrayOfStringsFrom(object:Any?) -> Array<String>{
        var resultArray = Array<String>()
        
        if object is Array<Any> {
            let array = object as! Array<Any>
            if array.count > 0 {
                for subObject in array {
                    let parsedObject = self.getStringValueFrom(object:subObject)
                    if parsedObject != nil{
                        resultArray.append(parsedObject!)
                    }
                    
                }
            }
        }else{
            let parsedObject = self.getStringValueFrom(object:object)
            if parsedObject != nil{
                resultArray.append(parsedObject!)
            }
        }
        
        return resultArray
    }
    
    class func getStringValueFrom(object:Any?) -> String? {
        if (object == nil) || (object is NSNull) {
            return nil
        }
        
        if object is NSNumber {
            return String(describing:object!)
        }
        
        if object is String {
            return (object as! String);
        }
        
        return nil;
    }
    
    
    // MARK: - Number
    class func numberFrom(object:Any?) -> NSNumber? {
        var obj = object;
        if obj is Array<Any> {
            let array = object as! Array<Any>
            if array.count > 0 {
                obj = array.first ;
            }else{
                return nil;
            }
        }
        return self.getNumberValueFrom(object: obj)
    }
    
    class func arrayOfNumbersFrom(object:Any?) -> Array<NSNumber>{
        var resultArray = Array<NSNumber>()
        
        if object is Array<Any> {
            let array = object as! Array<Any>
            if array.count > 0 {
                for subObject in array {
                    let parsedObject = self.getNumberValueFrom(object:subObject)
                    if parsedObject != nil{
                        resultArray.append(parsedObject!)
                    }
                    
                }
            }
        }else{
            let parsedObject = self.getNumberValueFrom(object:object)
            if parsedObject != nil{
                resultArray.append(parsedObject!)
            }
        }
        
        return resultArray
    }
    
    class func getNumberValueFrom(object:Any?) -> NSNumber? {
        if (object == nil) || (object is NSNull) {
            return nil
        }
        
        if object is NSNumber {
            return (object as! NSNumber)
        }
        
        if object is String {
            return NSNumber(value:Float(object as! String)!)
        }
        
        return nil;
    }
    
    // MARK: - Date
    
    class func dateFrom(object:Any?,format:String?,timeZone: TimeZone?) -> Date? {
        var obj = object;
        if obj is Array<Any> {
            let array = object as! Array<Any>
            if array.count > 0 {
                obj = array.first ;
            }else{
                return nil;
            }
        }
        return self.getDateValueFrom(object: obj,format: format,timeZone: timeZone)
    }
    
    class func arrayOfDateFrom(object:Any?,format:String?,timeZone: TimeZone?) -> Array<Date>{
        var resultArray = Array<Date>()
        
        if object is Array<Any> {
            let array = object as! Array<Any>
            if array.count > 0 {
                for subObject in array {
                    let parsedObject = self.getDateValueFrom(object: subObject,format: format,timeZone: timeZone)
                    if parsedObject != nil{
                        resultArray.append(parsedObject!)
                    }
                    
                }
            }
        }else{
            let parsedObject = self.getDateValueFrom(object: object,format: format,timeZone: timeZone)
            if parsedObject != nil{
                resultArray.append(parsedObject!)
            }
        }
        
        return resultArray
    }
    
    class func getDateValueFrom(object:Any?,format:String?,timeZone: TimeZone?) -> Date? {
        var date : Date?
        if format != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = format;
            /*if timeZone != nil {
                formatter.timeZone = timeZone!;
            }else{
                formatter.timeZone = TimeZone.current
            }
            //formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.locale = Locale.current*/
            let dateString = self.getStringValueFrom(object:object)
            if dateString == nil {
                return nil;
            }
            date = formatter.date(from: dateString!)
        }else{
            let dateNumber = self.getNumberValueFrom(object:object)
            if dateNumber == nil {
                return nil;
            }
            date = Date(timeIntervalSince1970:dateNumber!.doubleValue)
        }
        
        return date;
    }
    
}





