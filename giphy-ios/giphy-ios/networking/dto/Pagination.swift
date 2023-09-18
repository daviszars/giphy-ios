//
//  Pagination.swift
//  giphy-ios
//
//  Created by DavisZ on 15/09/2023.
//

import Foundation

struct Pagination {
    let count: Int
    let totalCount: Int
    let offset: Int
    
    init(from json: [String:Any]) {
        count = json["count"] as! Int
        totalCount = json["total_count"] as! Int
        offset = json["offset"] as! Int
    }
}
