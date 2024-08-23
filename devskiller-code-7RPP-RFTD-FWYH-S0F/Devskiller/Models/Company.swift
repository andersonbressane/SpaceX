//
//  Company.swift
//  Devskiller
//
//  Created by Anderson Franco on 23/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

struct Company: Codable {
    let name: String
    let founderName: String
    let foundedYear: Int
    let lauchSites: Int?
    let valuation: Double?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case founderName = "founder"
        case foundedYear = "founded"
        case lauchSites = "launch_sites"
        case valuation
    }
}
