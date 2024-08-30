//
//  Launch.swift
//  Devskiller
//
//  Created by Anderson Franco on 23/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation
import RealmSwift

// rocket name / type, days from / since today
// Image, successfull

struct Launch: Codable {
    let name: String?
    let details: String?
    let dateLocal: String?
    let dateUnix: TimeInterval?
    let dateUTC: String?
    let success: Bool?
    let rocket: Rocket?
    let links: Links?
    
    enum CodingKeys: String, CodingKey {
        case name, success, links, details, rocket
        case dateUTC = "date_utc"
        case dateLocal = "date_local"
        case dateUnix = "date_unix"
    }
    
    struct Links: Codable {
        let article: String?
        let wikipedia: String?
        let webcast: String?
        let patch: Patch?
        
        struct Patch: Codable {
            let small: String?
            let large: String?
        }
    }
    
    struct Rocket: Codable {
        let name: String?
        let type: String?
    }
}
