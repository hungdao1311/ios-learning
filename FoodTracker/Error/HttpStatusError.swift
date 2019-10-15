//
//  ErrorResponse.swift
//  FoodTracker
//
//  Created by Hung Dao on 10/10/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation

struct HttpStatusError : Error {
    let statusCode : Int
    let content: String
}
