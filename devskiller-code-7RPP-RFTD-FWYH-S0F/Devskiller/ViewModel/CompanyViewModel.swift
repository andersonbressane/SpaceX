//
//  CompanyViewModel.swift
//  Devskiller
//
//  Created by Anderson Franco on 25/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation
import Combine

protocol CompanyViewModelProtocol: ViewModelProtocol {
    func getCompany() -> AnyPublisher<CompanyLayoutViewModel, ErrorResult>
}

class CompanyViewModel: ViewModelProtocol {
    var loadState: LoadState = .none
    
    var layoutViewModel: CompanyLayoutViewModel?
    
    var cancellables = Set<AnyCancellable>()
    
    var dataSource: CompanyDataSourceProtocol
    
    init(dataSource: CompanyDataSourceProtocol = CompanyDataSource()) {
        self.dataSource = dataSource
    }
    
    func getCompany() -> AnyPublisher<CompanyLayoutViewModel, ErrorResult> {
        self.loadState = .loading
        
        let publisher = Future<CompanyLayoutViewModel, ErrorResult> { [weak self] promise in
            guard let self else { return }
            
            self.dataSource.getCompany().sink { completion in
                switch completion {
                case .finished:
                    DispatchQueue.main.async {
                        self.loadState = .none
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.loadState = .error(message: error.message)
                    }
                }
            } receiveValue: { [weak self] company in
                guard let self else { return }
                
                self.layoutViewModel = CompanyLayoutViewModel(company: company)
                
                DispatchQueue.main.async {
                    self.loadState = .success(message: nil)
                    
                    promise(.success(self.layoutViewModel!))
                }
                
            }.store(in: &self.cancellables)
        }
        
        return publisher.eraseToAnyPublisher()
    }
}
