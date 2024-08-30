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
    let page: Int
    let hasNextPage: Bool?
    let hasPrevPage: Bool?
    let totalDocs: Int?
    let limit: Int?
    let nextPage: Int?
    let prevPage: Int?
}
