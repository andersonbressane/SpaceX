//
//  Launch.swift
//  Devskiller
//
//  Created by Anderson Franco on 23/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

// rocket name / type, days from / since today
// Image, successfull
struct Launch: Codable {
    let id: String
    let flightNumber: Int
    let name: String
    let details: String
    let dateUTC: String
    let success: Bool?
    let rocket: String
    let links: Links
    
    enum CodingKeys: String, CodingKey {
        case id, name, success, rocket, links, details
        case flightNumber = "flight_number"
        case dateUTC = "date_utc"
    }
    
    struct Links: Codable {
        let article: String?
        let wikipedia: String?
        let webcast: String?
        
        struct Patch: Codable {
            let small: String?
            let large: String?
        }
        
        struct Flickr: Codable {
            let small: [String]
            let original: [String]
        }
    }
}
