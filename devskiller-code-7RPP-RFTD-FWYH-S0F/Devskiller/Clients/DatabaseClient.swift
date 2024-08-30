//
//  DatabaseClient.swift
//  Devskiller
//
//  Created by Anderson Franco on 30/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation
import RealmSwift

enum DatabaseError: Error {
    case noObject
    case noDataBase
    case notFound
    case parseError(_ model: String?)
    case notSaved(_ reason: String?)
    
    var message: String {
        switch self {
        case .noObject:
            "Database: No object to be saved"
        case .noDataBase:
            "Database: No database"
        case .notFound:
            "Database: Not found"
        case .parseError(let model):
            "Database: Not able to parse model \(model ?? "")"
        case .notSaved(let reason):
            "Database: Not saved \(reason ?? "")"
        }
    }
}

protocol DatabaseClientProtocol {
    func getCompany(completion: @escaping (Result<Company, DatabaseError>) -> Void)
    func getLaunches(completion: @escaping (Result<LaunchResponse, DatabaseError>) -> Void)
    
    func save(object: Object?, completion: @escaping (Result<Bool, DatabaseError>) -> Void)
}

class DatabaseClient: DatabaseClientProtocol {
    var service: Realm?
    
    func getCompany(completion: @escaping (Result<Company, DatabaseError>) -> Void) {
        self.getCompanyModel { result in
            switch result {
            case .success(let companyModel):
                guard let company = companyModel.convertToCodable() as? Company else { return completion(.failure(.parseError("Company Model"))) }
                completion(.success(company))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func getLaunches(completion: @escaping (Result<LaunchResponse, DatabaseError>) -> Void) {
        self.getLaunches { result in
            switch result {
            case .success(let lauchModel):
                guard let company = lauchModel.convertToCodable() as? LaunchResponse else { return completion(.failure(.parseError("LaunchResponse Model"))) }
                completion(.success(company))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func getCompanyModel(completion: @escaping (Result<CompanyModel, DatabaseError>) -> Void) {
        guard let realm = try? Realm() else { return completion(.failure(.noDataBase)) }
        
        guard let companyModel = realm.objects(CompanyModel.self).first else { return completion(.failure(.notFound)) }
        
        completion(.success(companyModel))
    }
    
    func getLaunches(completion: @escaping (Result<LaunchResponseModel, DatabaseError>) -> Void) {
        guard let realm = try? Realm() else { return completion(.failure(.noDataBase)) }
        
        guard let launchResponse = realm.objects(LaunchResponseModel.self).first else { return completion(.failure(.notFound)) }
        
        completion(.success(launchResponse))
    }
    
    func save(object: Object?, completion: @escaping (Result<Bool, DatabaseError>) -> Void) {
        guard let realm = try? Realm() else { return completion(.failure(.noDataBase)) }
        
        guard let object = object else { return }
        
        do {
            realm.beginWrite()
            
            realm.add(object)
            
            try realm.commitWrite()
            
            return completion(.success(true))
        } catch {
            return completion(.failure(.notSaved(error.localizedDescription)))
        }
    }
}
