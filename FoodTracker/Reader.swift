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

    func readObject<T>(_ name: String) throws -> T? where T : DataParseable {
        guard let data = values[name] as? Dictionary<String, Any> else {
            return nil
        }
        let reader = Reader(data)
        return try T(json: reader)
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
}

