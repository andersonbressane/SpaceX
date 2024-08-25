//
//  LaunchViewModel.swift
//  Devskiller
//
//  Created by Anderson Franco on 25/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation
import Combine

protocol LaunchViewModelProtocol: ViewModelProtocol  {
    func fetchLaunches(filter: LaunchFilter?) -> AnyPublisher<[LaunchLayoutViewModel], ErrorResult>
}

class LaunchViewModel: LaunchViewModelProtocol {
    var loadState: LoadState = .none
    
    var dataSource: LaunchDataSourceProtocol
    
    var cancellables = Set<AnyCancellable>()
    
    var launchFilter = LaunchFilter.default
    
    var layoutViewModels: [LaunchLayoutViewModel] = []
    
    var launchResponse: LaunchResponse?
    
    init(dataSource: LaunchDataSourceProtocol = LaunchDataSource()) {
        self.dataSource = dataSource
    }
    
    func resetFilter() {
        launchFilter = .default
        
        self.layoutViewModels = []
    }
    
    func fetchLaunches(filter: LaunchFilter?) -> AnyPublisher<[LaunchLayoutViewModel], ErrorResult> {
        self.loadState = .loading
        
        let publisher = Future<[LaunchLayoutViewModel], ErrorResult> { [weak self] promise in
            guard let self else { return }
            
            if self.launchResponse?.hasNextPage ?? true {
                self.dataSource.fetchLaunches(launchFilter: filter).sink { completion in
                    switch completion {
                    case .finished:
                        ()
                        self.loadState = .none
                    case .failure(let error):
                        self.loadState = .error(message: error.message)
                        promise(.failure(error))
                    }
                } receiveValue: { launchResponse in
                    self.loadState = .success(message: nil)
                    
                    self.launchResponse = launchResponse
                    
                    self.layoutViewModels.append(contentsOf: launchResponse.docs.compactMap({ LaunchLayoutViewModel(launch: $0) }))
                    
                    promise(.success(self.layoutViewModels))
                }.store(in: &self.cancellables)
            } else {
                promise(.failure(.noMoreData))
            }
        }
        
        return publisher.eraseToAnyPublisher()
        
        
    }
}
