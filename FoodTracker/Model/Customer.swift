//
//  Customer.swift
//  FoodTracker
//
//  Created by Hung Dao on 10/10/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation

struct Customer : DataParseable, CustomStringConvertible {
    var name: String
    var age: Int
    var point: Double
    
    init(name: String, age: Int, point: Double) {
        self.name = name
        self.age = age
        self.point = point
    }
    
    init(json reader: Reader) {
        self.init(
            name: reader.readString("name"),
            age: reader.readInt("age"),
            point: reader.readDouble("point")
        )
    }
    
    var description: String {
        return "Customer(name: \(name), age \(age), point \(point))"
    }
}
