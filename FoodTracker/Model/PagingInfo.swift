//
//  PagingInfo.swift
//  FoodTracker
//
//  Created by Hung Dao on 10/15/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation

struct PagingInfo: DataParseable {
    let pageSize: Int
    let pageNumber: Int
    let totalElements: Int
    let totalPages: Int
    
    init(pageSize: Int, pageNumber: Int, totalElements: Int, totalPages: Int) {
        self.pageSize = pageSize
        self.pageNumber = pageNumber
        self.totalPages = totalPages
        self.totalElements = totalElements
    }
    
    init(json: Reader) {
        self.init(
            pageSize: json.readInt("size"),
            pageNumber: json.readInt("number"),
            totalElements: json.readInt("totalElements"),
            totalPages: json.readInt("totalPages")
        )
    }
}
