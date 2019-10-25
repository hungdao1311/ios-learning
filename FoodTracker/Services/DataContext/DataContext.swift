//
//  DataContext.swift
//  DemoApp
//
//  Created by Hung Dao on 10/23/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation
import SQLite

class DataContext: SQLiteService {
    
    init() {
        super.init(name: "db.sqlite3",version: 1)
    }
    
    static var shared : DataContext = DataContext()
    
    var customerCaching: CustomerCaching = CustomerCaching()
    
    override func onCreate(db: Connection) {
        customerCaching.createTable(db: db)
    }
    
    override func onUpgrade(db: Connection, oldVersion: Int, newVersion: Int) {
        
    }
}
