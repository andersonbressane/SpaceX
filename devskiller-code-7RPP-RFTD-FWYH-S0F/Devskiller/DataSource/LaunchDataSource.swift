//
//  LaunchDataSource.swift
//  Devskiller
//
//  Created by Anderson Franco on 24/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

protocol LaunchDataSourceProtocol {
    func fetchLaunches(filter: LaunchFilter?, completion: @escaping (Result<LaunchResponse, ErrorResult>) -> Void)
}

class LaunchDataSource: LaunchDataSourceProtocol {
    private let networkClient: NetworkClientProtocol
    private let databaseClient: DatabaseClientProtocol
    
    var launchResponse: LaunchResponse?
    
    init(networkClient: NetworkClientProtocol = NetworkClient(), databaseClient: DatabaseClientProtocol = DatabaseClient()) {
        self.networkClient = networkClient
        self.databaseClient = databaseClient
    }
    
    func fetchLaunches(filter: LaunchFilter?, completion: @escaping (Result<LaunchResponse, ErrorResult>) -> Void) {
        
        if self.launchResponse == nil {
            self.getCache(completion: completion)
        }
        
        var endPoint = LaunchEndpoint(.getLaunches)
        
        if let launchFilter = filter {
            guard let dictionary = launchFilter.toDictionary else {
                completion(.failure(ErrorResult.parsingError(object: String(describing: LaunchFilter.self))))
                return
            }
            
            endPoint = LaunchEndpoint(.queryLaunches, parameters: dictionary)
        }
        
        self.networkClient.dataTask(endpoint: endPoint) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                guard let launches = try? JSONDecoder().decode(LaunchResponse.self, from: data) else {
                    completion(.failure(ErrorResult.parsingError(object: String(describing: LaunchResponse.self))))
                    return
                }
                
                self.cacheData(launchResponse: launches)
                
                self.launchResponse = launches
                
                completion(.success(launches))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func cacheData(launchResponse: LaunchResponse) {
        guard let launchResponse = LaunchResponseModel.convertFrom(object: launchResponse) else { return }
        
        self.databaseClient.save(object: launchResponse) { _ in }
    }
    
    private func getCache(completion: @escaping (Result<LaunchResponse, ErrorResult>) -> Void) {
        self.databaseClient.getLaunches { result in
            switch result {
            case .success(let launches):
                completion(.success(launches))
                
                print("Database: returned cached Launches")
                return
            case .failure(let failure):
                print("Database: not able to fetch cache \(failure.message)")
            }
        }
    }
}
