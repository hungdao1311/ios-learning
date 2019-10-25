//
//  CustomerCaching.swift
//  DemoApp
//
//  Created by Hung Dao on 10/22/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation
import SQLite
class CustomerCaching {
    
    let table = Table("customers")
    let id = Expression<String>("id")
    let firstName = Expression<String>("firstName")
    let lastName = Expression<String>("lastName")
    let editable = Expression<Bool>("editable")
    
    func createTable(db: Connection) {
        try! db.run(table.create {t in
            t.column(id, primaryKey: true)
            t.column(firstName)
            t.column(lastName)
            t.column(editable)
        })
    }
    func save(data: [Customer]) throws{
        let db = DataContext.shared.db
        for customer in data {
            try db.run(table.insert(or: .replace, id <- customer.id, firstName <- customer.firstName, lastName <- customer.lastName, editable <- customer.editable))
        }
    }
    
    func load(queryString: String = "") throws -> [Customer]  {
        let db = DataContext.shared.db
        var result = [Customer]()
        for row in try db.prepare(table.filter(firstName.like("%\(queryString)%") || lastName.like("%\(queryString)%"))){
            result.append(Customer(id: row[self.id], firstName: row[self.firstName], lastName: row[self.lastName], editable: row[self.editable]))
        }
        return result
    }
}
