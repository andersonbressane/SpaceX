//
//  CompanyDataSource.swift
//  Devskiller
//
//  Created by Anderson Franco on 23/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

protocol CompanyDataSourceProtocol {
    func getCompany(completion: @escaping (Result<Company, ErrorResult>) -> Void)
}

class CompanyDataSource: CompanyDataSourceProtocol {
    private let networkClient: NetworkClientProtocol
    private let databaseClient: DatabaseClientProtocol
    
    init(networkClient: NetworkClientProtocol = NetworkClient(), databaseClient: DatabaseClientProtocol = DatabaseClient()) {
        self.networkClient = networkClient
        self.databaseClient = databaseClient
    }
    
    func getCompany(completion: @escaping (Result<Company, ErrorResult>) -> Void) {
        self.setCache(completion: completion)
        
        self.networkClient.dataTask(endpoint: CompanyEndpoint(actionEnum: .getCompany)) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                guard let company = try? JSONDecoder().decode(Company.self, from: data) else {
                    completion(.failure(ErrorResult.parsingError(object: String(describing: Company.self))))
                    return
                }
                
                self.cacheData(company: company)
                
                completion(.success(company))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func cacheData(company: Company) {
        guard let companyModel = CompanyModel.convertFrom(object: company) else { return }
        
        self.databaseClient.save(object: companyModel) { _ in }
    }
    
    private func setCache(completion: @escaping (Result<Company, ErrorResult>) -> Void) {
        self.databaseClient.getCompany { result in
            switch result {
            case .success(let company):
                completion(.success(company))
                
                print("Database: returned cached Company")
                return
            case .failure(let failure):
                print("Database: not able to fetch cache \(failure.message)")
            }
        }
    }
}
