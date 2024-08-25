//
//  CompanyDataSource.swift
//  Devskiller
//
//  Created by Anderson Franco on 23/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation
import Combine

protocol CompanyDataSourceProtocol: DataSourceProtocol {
    func getCompany() -> AnyPublisher<Company, ErrorResult>
}

class CompanyDataSource: CompanyDataSourceProtocol {
    var cancellables = Set<AnyCancellable>()
    
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func getCompany() -> AnyPublisher<Company, ErrorResult> {
        let publisher = Future<Company, ErrorResult> { [weak self] promise in
            guard let self else { return }
            
            self.networkClient.dataTask(endpoint: CompanyEndpoint(actionEnum: .getCompany)).sink { completion in
                switch completion {
                case .finished:
                    ()
                case .failure(let error):
                    promise(.failure(error))
                }
            } receiveValue: { data in
                guard let company = try? JSONDecoder().decode(Company.self, from: data) else {
                    promise(.failure(ErrorResult.parsingError(object: String(describing: Company.self))))
                    return
                }
                
                promise(.success(company))
            }.store(in: &self.cancellables)
        }
        
        return publisher.eraseToAnyPublisher()
    }
}
