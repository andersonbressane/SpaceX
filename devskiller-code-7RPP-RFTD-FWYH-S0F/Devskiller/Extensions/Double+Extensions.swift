//
//  Double+Extensions.swift
//  Devskiller
//
//  Created by Anderson Franco on 25/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

var numberFormatter: NumberFormatter {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = .current
    return numberFormatter
}

extension Double {
    func toCurrency(locale: Locale? = .current) -> String {
        numberFormatter.locale = locale
        numberFormatter.numberStyle = .currency
        
        return numberFormatter.string(from: NSNumber(floatLiteral: self)) ?? "0"
    }
}
