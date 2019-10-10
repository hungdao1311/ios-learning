//
//  Response.swift
//  FoodTracker
//
//  Created by Hung Dao on 10/10/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation

struct Response : DataParseable, CustomStringConvertible {
    let customer: Customer?
    let url: String
    
    var description: String {
        return "URL: \(url)\n\(customer?.description ?? "")"
    }
    init(customer: Customer, url: String) {
        self.customer = customer
        self.url = url
    }
    
    init(json reader: Reader) throws{
        customer = try reader.readObject("args")
        url = reader.readString("url")
    }
}
