//
//  CompanyLayoutViewModel.swift
//  Devskiller
//
//  Created by Anderson Franco on 25/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

class CompanyLayoutViewModel {
    private var company: Company
    
    init(company: Company) {
        self.company = company
    }
    
    var name: String {
        self.company.name
    }
    
    var founder: String {
        self.company.founderName
    }
    
    var foundedYear: Int {
        self.company.foundedYear
    }
    
    var employees: Int {
        self.company.employees ?? 0
    }
    
    var launchSites: Int {
        self.company.lauchSites ?? 0
    }
    
    var valuation: Double {
        self.company.valuation ?? 0.0
    }
    
    var valuationString: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        
        return formatter.string(from: NSNumber(floatLiteral: self.valuation)) ?? "0"
    }
    
    func getString() -> String {
        return "\(self.name) was founded by \(self.founder) in \(self.foundedYear). It has now \(self.employees) employees, \(self.launchSites) launch sites, and is valued at \(self.valuationString) USD"
    }
}
