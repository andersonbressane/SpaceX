//
//  Company.swift
//  Devskiller
//
//  Created by Anderson Franco on 23/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

protocol CompanyProtocol: Codable {
    var name: String? { get }
    var founderName: String? { get }
    var foundedYear: Int? { get }
    var employees: Int? { get }
    var lauchSites: Int? { get }
    var valuation: Double? { get }
}

struct Company: Codable {
    let name: String?
    let founderName: String?
    let foundedYear: Int?
    let employees: Int?
    let lauchSites: Int?
    let valuation: Double?
    
    enum CodingKeys: String, CodingKey {
        case name, valuation, employees
        case founderName = "founder"
        case foundedYear = "founded"
        case lauchSites = "launch_sites"
    }
}
