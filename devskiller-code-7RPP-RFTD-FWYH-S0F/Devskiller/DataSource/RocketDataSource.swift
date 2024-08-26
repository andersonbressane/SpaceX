//
//  RocketDataSource.swift
//  Devskiller
//
//  Created by Anderson Franco on 26/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation
import Combine

protocol RocketDataSourceProtocol: DataSourceProtocol {
    func fetchRocket(id: String) -> AnyPublisher<Rocket, ErrorResult>
}

class RocketDataSource: RocketDataSourceProtocol {
    var cancellables = Set<AnyCancellable>()
    
    let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchRocket(id: String) -> AnyPublisher<Rocket, ErrorResult> {
        let publisher = Future<Rocket, ErrorResult> { [weak self] promise in
            guard let self else { return }
            
            self.networkClient.dataTask(endpoint: RocketEndpoint(actionEnum: .getRocket(id: id))).sink { completion in
                switch completion {
                case .finished:
                    ()
                case .failure(let error):
                    promise(.failure(error))
                }
            } receiveValue: { data in
                guard let rocket = try? JSONDecoder().decode(Rocket.self, from: data) else {
                    promise(.failure(ErrorResult.parsingError(object: String(describing: Rocket.self))))
                    return
                }
                
                promise(.success(rocket))
            }.store(in: &self.cancellables)
        }
        
        return publisher.eraseToAnyPublisher()
    }
}
