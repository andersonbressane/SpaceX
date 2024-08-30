//
//  CompanyModel.swift
//  Devskiller
//
//  Created by Anderson Franco on 30/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation
import RealmSwift

class CompanyModel: Object, CompanyProtocol, DataBaseModelProtocol {
    @Persisted var name: String?
    @Persisted var founderName: String?
    @Persisted var foundedYear: Int?
    @Persisted var employees: Int?
    @Persisted var lauchSites: Int?
    @Persisted var valuation: Double?
    
    static func convertFrom<T>(object: T) -> RealmSwift.Object? where T : Decodable, T : Encodable  {
        guard let object = object as? Company else { return nil }
        
        let companyModel = CompanyModel()
        
        companyModel.name = object.name
        companyModel.founderName = object.founderName
        companyModel.foundedYear = object.foundedYear
        companyModel.employees = object.employees
        companyModel.lauchSites = object.lauchSites
        companyModel.valuation = object.valuation
        
        return companyModel
    }
    
    func convertToCodable() -> Codable? {
        let company = Company(
            name: self.name,
            founderName: self.founderName,
            foundedYear: self.foundedYear,
            employees: self.employees,
            lauchSites: self.lauchSites,
            valuation: self.valuation)
        
        return company
    }
}
