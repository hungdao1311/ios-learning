//
//  CustomerResponse.swift
//  FoodTracker
//
//  Created by Hung Dao on 10/17/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation

class CustomerResponse: ListResponse<Customer>, DataParseable {
    required init (json reader: Reader) throws {
        try super.init(json: reader, fieldName: "recipients")
    }
}
