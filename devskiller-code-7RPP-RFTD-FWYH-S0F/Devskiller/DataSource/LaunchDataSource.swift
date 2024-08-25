//
//  LaunchDataSource.swift
//  Devskiller
//
//  Created by Anderson Franco on 24/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation
import Combine

protocol LaunchDataSourceProtocol: DataSourceProtocol {
    func fetchLaunches(launchFilter: LaunchFilter?) -> AnyPublisher<LaunchResponse, ErrorResult>
}

class LaunchDataSource: LaunchDataSourceProtocol {
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchLaunches(launchFilter: LaunchFilter?) -> AnyPublisher<LaunchResponse, ErrorResult> {
        let publisher = Future<LaunchResponse, ErrorResult> { [weak self] promise in
            guard let self else { return }
            
            var endPoint = LaunchEndpoint(.getLaunches)
            
            if let launchFilter = launchFilter {
                guard let dictionary = launchFilter.toDictionary else {
                    promise(.failure(ErrorResult.parsingError(object: String(describing: LaunchFilter.self))))
                    return
                }
                
                endPoint = LaunchEndpoint(.queryLaunches, parameters: dictionary)
            }
            
            self.networkClient.dataTask(endpoint: endPoint).sink { completion in
                switch completion {
                case .finished:
                    ()
                case .failure(let error):
                    promise(.failure(error))
                }
            } receiveValue: { data in
                guard let launches = try? JSONDecoder().decode(LaunchResponse.self, from: data) else {
                    promise(.failure(ErrorResult.parsingError(object: String(describing: LaunchResponse.self))))
                    return
                }
                
                promise(.success(launches))
            }.store(in: &self.cancellables)
        }
        
        return publisher.eraseToAnyPublisher()
    }
}
