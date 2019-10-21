//
//  Customer.swift
//  FoodTracker
//
//  Created by Hung Dao on 10/10/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation

struct Customer : DataParseable, CustomStringConvertible {
    var id: String
    var firstName: String
    var lastName: String
    var editable: Bool
    
    var fullName: String {
        return ("\(firstName) \(lastName)")
    }
    
    init(id: String, firstName: String, lastName: String, editable: Bool) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.editable = editable
    }
    
    init(json reader: Reader) {
        self.init(
            id: reader.readString("id"),
            firstName: reader.readString("firstName"),
            lastName: reader.readString("lastName"),
            editable: reader.readBool("editable")
        )
    }
    
    var description: String {
        return ""
    }
}
