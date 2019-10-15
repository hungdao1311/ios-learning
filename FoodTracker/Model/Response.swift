//
//  Response.swift
//  FoodTracker
//
//  Created by Hung Dao on 10/10/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation

struct Response : DataParseable{
    let customerList: [Customer]
    let url: String
    let pagingInfo: PagingInfo?
    
    
    init(json reader: Reader) throws {
        url = reader.readNestedObject("_links").readNestedObject("self").readString("href")
        pagingInfo = try reader.readObject("page")
        customerList = try reader.readNestedObject("_embedded").readList("recipients")
    }
}
