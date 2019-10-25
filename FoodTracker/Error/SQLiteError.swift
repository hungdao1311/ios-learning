//
//  SQLiteError.swift
//  DemoApp
//
//  Created by Hung Dao on 10/23/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation

enum SQLiteError: Error {
    case NoDatabaseConnection
    case TableCreatingError
}
