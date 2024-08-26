//
//  Date+Extensions.swift
//  Devskiller
//
//  Created by Anderson Franco on 25/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

var ISODateFormatter: ISO8601DateFormatter {
    let dateFormatter = ISO8601DateFormatter()
    return dateFormatter
}

extension Date {
    static func dateFromString(_ string: String?, format: String? = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> Date? {
        guard let string = string else { return nil }
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = format
        dateFormater.locale = .current
        return dateFormater.date(from: string)
    }
    
    func getFormattedDateString(format: String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = format
        dateFormater.locale = .current
        
        dateFormater.dateStyle = .long
        dateFormater.timeStyle = .short
        return dateFormater.string(from: self)
    }
    
    static func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let calendar = Calendar.current
        guard let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: from), to: calendar.startOfDay(for: to)).day else {
            return 0
        }
        
        return days
    }
}
