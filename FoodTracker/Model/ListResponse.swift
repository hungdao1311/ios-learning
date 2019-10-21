//
//  Response.swift
//  FoodTracker
//
//  Created by Hung Dao on 10/10/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation

class ListResponse<T: DataParseable> {
    let data: [T]
    let pagingInfo: PagingInfo

    init(json reader: Reader, fieldName: String) throws {
        pagingInfo = try reader.readObject("page")
        data = try reader.readNestedObject("_embedded").readList(fieldName)
    }
}
