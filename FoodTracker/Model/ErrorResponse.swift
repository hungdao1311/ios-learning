//
//  ErrorResponse.swift
//  FoodTracker
//
//  Created by Hung Dao on 10/10/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation

struct ErrorResponse: DataParseable, CustomStringConvertible {
    var error: String
    var errorDescription: String
    
    init(error: String, errorDescription: String) {
        self.error = error
        self.errorDescription = errorDescription
    }
    
    init(json: Reader) {
        self.init(
            error: json.readString("error"),
            errorDescription: json.readString("error_description")
        )
    }
    
    var description: String {
        return "error: \(errorDescription)"
    }
}
