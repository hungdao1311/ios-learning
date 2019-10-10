//
//  Body.swift
//  FoodTracker
//
//  Created by Hung Dao on 10/9/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation
protocol Body {
    var contentType: String { get }
    var content: String { get }
}

struct JsonBody : Body {
    private let body : [String: Any]
    init(_ body: [String: Any]) {
        self.body = body
    }
    
    var contentType: String {
        return "application/json"
    }
    var content: String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            return String(data: jsonData, encoding: .ascii) ?? ""
        } catch {
            fatalError("Cannot convert dictionary to json string")
        }
    }
}

struct UrlEncodedBody : Body {
    private let body : [String: Any]
    init(_ body: [String: Any]) {
        self.body = body
    }

    var contentType: String {
        return "application/x-www-form-urlencoded"
    }
    
    var content: String {
        var bodyString = ""
        for (key, value) in self.body {
            switch value {
            case is String, is Double, is Int, is Bool:
                bodyString += "\(key)=\(value)&"
            case is Date:
                let dateValue = value as! Date
                bodyString += "\(key)=\(dateValue.iso8601)&"
            default:
                fatalError("Type of \(type(of: value)) is not supported")
            }
        }
        return String(bodyString.dropLast())
    }
    
}
