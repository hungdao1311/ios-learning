//
//  DataParseable.swift
//  FoodTracker
//
//  Created by Hung Dao on 10/10/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation

protocol DataParseable {
    init(json reader: Reader) throws
}

func parseObject<T>(content: String) throws -> T where T: DataParseable {
    let dict = try convertToDictionary(text: content)
    let reader = Reader(dict)
    return try T(json: reader)
}

func convertToDictionary(text: String) throws -> [String: Any] {
       if let data = text.data(using: .utf8) {
           let jsonObject: Any
           do {
               jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
           } catch {
               throw ParserError.JsonParsing
           }
           if let dict = jsonObject as? [String: Any] {
               return dict
           } else {
               throw ParserError.DictionaryCasting
           }
       } else {
           throw ParserError.EmptyResponse
       }
   }
