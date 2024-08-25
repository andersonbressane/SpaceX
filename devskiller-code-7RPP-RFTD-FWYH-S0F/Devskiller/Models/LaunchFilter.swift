//
//  LaunchFilter.swift
//  Devskiller
//
//  Created by Anderson Franco on 25/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

struct LaunchFilter: Codable {
    var option: Option?
    var query: Query?
    
    struct Option: Codable {
        var page: Int
        var limit: Int
        var order: Order
        var pagination: Bool
        
        enum Order: String, Codable {
            case asc
            case desc
        }
    }
    
    struct Query: Codable {
        var year: Int
        var successfull: Bool
    }
    
    static let `default` = LaunchFilter(option: .init(page: 1, limit: 1, order: .desc, pagination: true))
}
