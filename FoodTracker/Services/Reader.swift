//
//  Reader.swift
//  FoodTracker
//
//  Created by Hung Dao on 10/7/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation

class Reader {
    var values = [String: Any]()
    
    init(_ dict:[String: Any]) {
        self.values = dict
    }
    
    convenience init(json: String) throws {
        try self.init(convertToDictionary(text: json))
    }

    func readObject<T>(_ name: String) throws -> T where T : DataParseable {
        guard let data = values[name] as? Dictionary<String, Any> else {
            throw RequiredFieldError(name: name)
        }
        let reader = Reader(data)
        return try T(json: reader)
    }
    
    func readNestedObject(_ name: String) throws -> Reader {
        guard let data = values[name] as? Dictionary<String, Any> else {
            throw RequiredFieldError(name: name)
        }
        return Reader(data)
    }
    
    func readList<T>(_ name: String) throws -> [T] where T: DataParseable {
        var result = [T]()
        guard let data = values[name] as? Array<Any> else {
            throw RequiredFieldError(name: name)
        }
        for element in data {
            guard let jsonElement = element as? Dictionary<String, Any> else {
                continue
            }
            let reader = Reader(jsonElement)
            result.append(try T(json: reader))
        }
        return result
    }
    
    func readString(_ name: String) -> String {
        let value = values[name]
        if let stringValue = value as? String {
            return stringValue
        }
        
        if let numberValue = value as? Int{
            return String(numberValue)
        }
        
        return ""
    }
    
    func readInt(_ name: String) -> Int {
        let value = values[name]
        
        if let intValue = value as? Int {
            return intValue
        }
        if let stringValue = value as? String {
            return Int(stringValue) ?? 0
        }
        if let doubleValue = value as? Double {
            return Int(doubleValue)
        }
        
        return 0
    }
    
    func readDouble(_ name: String) -> Double {
        let value = values[name]
        if let intValue = value as? Int {
            return Double(intValue)
        }
        if let doubleValue = value as? Double {
            return doubleValue
        }
        if let stringValue = value as? String {
            return Double(stringValue) ?? 0
        }
        return 0
    }
    
    func readBool(_ name: String) -> Bool {
        let value = values[name]
        if let boolValue = value as? Bool {
            return boolValue
        }
        if let stringValue = value as? String {
            guard let boolValue = Bool(stringValue) else {
                return false
            }
            return boolValue
        }
        return false
    }
    
    func readDate(_ name: String) -> Date {
        let value = values[name]
        if let doubleValue = value as? Double {
            return Date(timeIntervalSince1970: doubleValue)
        }
        if let intValue = value as? Int {
            return Date(timeIntervalSince1970: Double(intValue))
        }
        if let stringValue = value as? String {
            return Date(timeIntervalSince1970: Double(stringValue) ?? 0.0)
        }
        return Date()
    }
}

