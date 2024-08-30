//
//  LaunchViewModel.swift
//  Devskiller
//
//  Created by Anderson Franco on 25/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

enum LaunchViewModelError: Error {
    case InvalidDate
}

protocol LaunchViewModelProtocol: ViewModelProtocol  {
    func fetchMore(completion: @escaping (Result<Bool, ErrorResult>) -> Void)
    func resetFilter(completion: @escaping (Result<Bool, ErrorResult>) -> Void)
    func fetchLaunches(_ filter: LaunchFilter?, completion: @escaping (Result<Bool, ErrorResult>) -> Void)
    func fetchLaunches(year: Int?, success: Bool?, order: LaunchFilter.Options.Order?, completion: @escaping (Result<Bool, ErrorResult>) -> Void)
    var layoutViewModels: [LaunchLayoutViewModel] { get }
}

class LaunchViewModel: LaunchViewModelProtocol {
    
    var loadState: LoadState = .none
    
    var layoutViewModels: [LaunchLayoutViewModel] = []
    
    private enum Constants {
        static let dateUTC = "date_unix"
        static let greaterThan = "$gte"
        static let lessThan = "$lte"
        static let dateFrom = "%d-01-01T00:00:00.000Z"
        static let dateTo = "%d-12-31T23:59:59.999Z"
    }
    
    var dataSource: LaunchDataSourceProtocol
    
    var launchFilter = LaunchFilter.default
    
    var launchResponse: LaunchResponse?
    init(dataSource: LaunchDataSourceProtocol = LaunchDataSource()) {
        self.dataSource = dataSource
    }
    
    var isFetching = false
    
    func resetFilter(completion: @escaping (Result<Bool, ErrorResult>) -> Void) {
        launchFilter = .default
        
        self.launchResponse = nil
        self.layoutViewModels = []
        
        self.fetchLaunches(self.launchFilter, completion: completion)
    }
    
    func fetchMore(completion: @escaping (Result<Bool, ErrorResult>) -> Void) {
        self.launchFilter.options?.page = self.launchResponse?.nextPage ?? 1
        
        fetchLaunches(self.launchFilter, completion: completion)
    }
    
    func fetchLaunches(year: Int?, success: Bool?, order: LaunchFilter.Options.Order?, completion: @escaping (Result<Bool, ErrorResult>) -> Void) {
        self.launchFilter = .default
        
        self.launchResponse = nil
        
        self.layoutViewModels = []
        
        self.launchFilter.query = LaunchFilter.Query(date_utc: createYearFilter(year: year), success: success)
        
        self.launchFilter.options?.sort = [Constants.dateUTC: order ?? .desc]
        
        fetchLaunches(self.launchFilter, completion: completion)
    }
    
    func fetchLaunches(_ filter: LaunchFilter?, completion: @escaping (Result<Bool, ErrorResult>) -> Void) {
        isFetching = true
        
        self.loadState = .loading
          
        if let filter = filter {
            self.launchFilter = filter
        }
        
        if self.launchResponse?.hasNextPage ?? true {
            
            self.dataSource.fetchLaunches(filter: filter) { [weak self] result in
                guard let self else { return }
                self.isFetching = false
                
                self.loadState = .none
                
                switch result {
                case .success(let launchResponse):
                    self.launchResponse = launchResponse
                    
                    if self.launchResponse?.totalDocs == 0 && self.launchResponse?.page == 1 {
                        completion(.failure(.noResult))
                    } else {
                        self.layoutViewModels.append(contentsOf: launchResponse.docs.compactMap({ LaunchLayoutViewModel(launch: $0) }))
                    }
                    
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(.noMoreData))
        }
    }
    
    // Date filter
    private func createYearFilter(year: Int?) -> [String:String]? {
        guard let year = year else { return nil }
        
        return [Constants.greaterThan: String(format: Constants.dateFrom, year), Constants.lessThan: String(format: Constants.dateTo, year)]
    }
    
    // Filter
    func createFilterQuery(year: Int?, success: Bool?, order: LaunchFilter.Options.Order?) -> LaunchFilter.Query {
        let filter = LaunchFilter.Query(date_utc: createYearFilter(year: year), success: success)
        
        self.launchFilter.options?.sort = [Constants.dateUTC: order ?? .desc]
        
        return filter
    }
}
