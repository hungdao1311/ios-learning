//
//  SQLiteService.swift
//  DemoApp
//
//  Created by Hung Dao on 10/22/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation
import SQLite

class SQLiteService {
    let version : Int
    
    init(name: String, version: Int) {
        self.version = version
        let dbPath = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true).first!
        db = try! Connection("\(dbPath)/\(name)")
        let theirVersion = Int(db.userVersion)
        if theirVersion == 0 {
            onCreate(db: db)
        } else if theirVersion < version {
            onUpgrade(db: db, oldVersion: theirVersion, newVersion: version)
        } else if theirVersion > version {
            onDowngrade(db: db, oldVersion: theirVersion, newVersion: version)
        }
        db.userVersion = Int32(version)
    }
    
    open func onCreate(db: Connection) {
        
    }
    
    open func onUpgrade(db: Connection, oldVersion: Int, newVersion: Int) {
        
    }
    
    open func onDowngrade(db: Connection, oldVersion: Int, newVersion: Int) {
        
    }
    
    var db: Connection
}
