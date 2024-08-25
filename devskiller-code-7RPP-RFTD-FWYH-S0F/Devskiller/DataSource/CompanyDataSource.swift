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
    var loadState: LoadState = .none
    
    var cancellables = Set<AnyCancellable>()
    
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func getCompany() -> AnyPublisher<Company, ErrorResult> {
        self.loadState = .isLoading
        
        let returnPublisher = Future<Company, ErrorResult> { [weak self] promise in
            guard let self else { return }
            
            let publisher = self.networkClient.dataTask(endpoint: CompanyEndpoint(actionEnum: .getCompany))
            
            publisher.sink { completion in
                switch completion {
                case .finished:
                    self.loadState = .none
                case .failure(let error):
                    self.loadState = .error(message: error.message)
                    
                    promise(.failure(error))
                }
            } receiveValue: { data in
                guard let company = try? JSONDecoder().decode(Company.self, from: data) else {
                    promise(.failure(ErrorResult.parsingError(object: String(describing: Company.self))))
                    return
                }
                
                self.loadState = .success(message: nil)
                
                promise(.success(company))
            }.store(in: &self.cancellables)
        }
        
        return returnPublisher.eraseToAnyPublisher()
    }
}
