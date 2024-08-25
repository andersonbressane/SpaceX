//
//  LaunchResponse.swift
//  Devskiller
//
//  Created by Anderson Franco on 25/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

struct LaunchResponse: Codable {
    let docs: [Launch]
    
    let offset: Int
    let totalPages: Int
    var page: Int
    var hasNextPage: Bool
    var hasPrevPage: Bool
    var limit: Int
    let nextPage: Int?
    let prevPage: Int?
}
