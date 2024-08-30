//
//  Constants.swift
//  Devskiller
//
//  Created by Anderson Franco on 24/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

let API_BASE_URL = "https://api.spacexdata.com/v4/"
let API_VERSION = "v4/"
let API_LAUNCHES_URL = "launches"
let API_LAUNCHES_QUERY_URL = "launches/query"
let API_ROCKET_ID_URL = "rockets/"
let API_COMPANY_URL = "company"

let TWENTY_SECONDS = 20
let FIVE_MINUTES = 300
let TWENTY_FOUR_HOURS = 86400
let INDEX_TO_LOAD_MORE = 4
let YEAR_FOUNDED = 2002
let YEAR_TODAY: Int = {
    let year = Calendar.current.component(.year, from: Date())
    return year
}()
