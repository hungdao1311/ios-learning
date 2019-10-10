//
//  ParserError.swift
//  FoodTracker
//
//  Created by Hung Dao on 10/10/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation

enum ParserError: Error {
    case JsonParsing
    case DictionaryCasting
    case EmptyResponse
}
