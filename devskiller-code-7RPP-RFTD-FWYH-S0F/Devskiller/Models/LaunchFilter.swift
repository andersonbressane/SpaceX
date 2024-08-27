//
//  LaunchFilter.swift
//  Devskiller
//
//  Created by Anderson Franco on 25/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

struct LaunchFilter: Codable {
    var options: Options?
    var query: Query?
    
    struct Options: Codable {
        var page: Int
        var limit: Int
        var pagination: Bool
        var populate: [String]?
        var sort: [String: Order]?
        
        enum Order: String, Codable {
            case asc
            case desc
        }
    }
    
    struct Query: Codable {
        var date_utc: [[String: String]]?
        var success: Bool?
    }
    
    static let `default` = LaunchFilter(options: .init(page: 1, limit: 10, pagination: true, populate: ["rocket"], sort: ["date_unix": .desc]), query: .init(date_utc: /*[["$gte":"2021-01-01T00:00:00.000Z"], ["$lte":"2022-01-01T00:00:00.000Z"]]*/ nil, success: true))
}
