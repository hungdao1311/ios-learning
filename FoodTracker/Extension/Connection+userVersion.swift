//
//  Connection+userVersion.swift
//  DemoApp
//
//  Created by Hung Dao on 10/24/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import SQLite

extension Connection {
    
    public var userVersion: Int32 {
        get {
            do {
                return Int32(try scalar("PRAGMA user_version") as! Int64)
            } catch {
                return 0
            }
        }
        set { try! run("PRAGMA user_version = \(newValue)") }
    }
}

