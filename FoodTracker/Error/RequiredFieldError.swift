//
//  RequiredFieldError.swift
//  FoodTracker
//
//  Created by Hung Dao on 10/16/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation

struct RequiredFieldError: Error {
    let name: String
}

extension RequiredFieldError: LocalizedError {
    var errorDescription: String? {
        return "\(name) is required"
    }
}
