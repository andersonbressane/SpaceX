//
//  LaunchViewModel.swift
//  Devskiller
//
//  Created by Anderson Franco on 25/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation
import Combine

enum LaunchViewModelError: Error {
    case InvalidDate
}

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
    
    // clear
    func resetFilter() {
        launchFilter = .default
        
        self.isSearching = false
        
        self.launchResponse = nil
        self.layoutViewModels = []
        
        fetchLaunches(launchFilter)
    }
    
    // Pagination
    func loadMore() {
        self.launchFilter.options?.page = self.launchResponse?.nextPage ?? 1
        
        fetchLaunches(self.launchFilter)
    }
    
    // Filter
    func fetchLaunches(year: Int? = nil, success: Bool? = nil, order: LaunchFilter.Options.Order? = .desc) {
        self.launchFilter.query = LaunchFilter.Query(date_utc: createYearFilter(year: year), success: success)
        
        if let order = order {
            self.launchFilter.options?.sort = ["date_unix": order]
        }
        
        fetchLaunches(self.launchFilter)
    }
    
    // Date filter
    func createYearFilter(year: Int?) -> [String:String]? {
        guard let year = year else { return nil }
        
        return ["$gte": "\(year)-01-01T00:00:00.000Z", "$lte": "\(year)-12-31T23:59:59.999Z"]
    }
    
    // Fetch
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
                
                self.launchResponse = launchResponse
                
                self.layoutViewModels.append(contentsOf: launchResponse.docs.compactMap({ LaunchLayoutViewModel(launch: $0) }))
                
            }.store(in: &self.cancellables)
        }
    }
}
