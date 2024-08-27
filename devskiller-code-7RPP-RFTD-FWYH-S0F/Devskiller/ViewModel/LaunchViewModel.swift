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
    func fetchLaunches(_ searchFilter: LaunchFilter?)
}

class LaunchViewModel: LaunchViewModelProtocol {
    @Published var loadState: LoadState = .none
    @Published private(set) var layoutViewModels: [LaunchLayoutViewModel] = []
    
    var dataSource: LaunchDataSourceProtocol
    
    var cancellables = Set<AnyCancellable>()
    
    var launchFilter = LaunchFilter.default
    
    var launchResponse: LaunchResponse?
    
    var isSearching: Bool = false
    
    init(dataSource: LaunchDataSourceProtocol = LaunchDataSource()) {
        self.dataSource = dataSource
    }
    
    func resetFilter() {
        launchFilter = .default
        
        self.isSearching = false
        
        self.launchResponse = nil
        self.layoutViewModels = []
        
        fetchLaunches(launchFilter)
    }
    
    func loadMore() {
        fetchLaunches(self.launchFilter)
    }
    
    func fetchLaunches(_ searchFilter: LaunchFilter?) {
        self.loadState = .loading
        
        if let searchFilter = searchFilter {
            self.launchFilter = searchFilter
            self.isSearching = true
        }
        
        if self.launchResponse?.hasNextPage ?? true {
            self.dataSource.fetchLaunches(launchFilter: self.launchFilter).sink { completion in
                switch completion {
                case .finished:
                    ()
                    
                    self.loadState = .none
                case .failure(let error):
                    self.loadState = .error(message: error.message)
                }
            } receiveValue: { [weak self] launchResponse in
                guard let self else { return }
                
                self.loadState = .success(message: nil)
                
                self.launchFilter.options?.page = self.launchResponse?.nextPage ?? 1
                
                self.launchResponse = launchResponse
                
                self.layoutViewModels.append(contentsOf: launchResponse.docs.compactMap({ LaunchLayoutViewModel(launch: $0) }))
                
            }.store(in: &self.cancellables)
        }
    }
}
