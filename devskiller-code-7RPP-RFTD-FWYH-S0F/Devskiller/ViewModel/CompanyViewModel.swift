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
    func getCompany(completion: @escaping (Result<CompanyLayoutViewModel, ErrorResult>) -> Void)
}

class CompanyViewModel: CompanyViewModelProtocol {
    var loadState: LoadState = .none
    
    @Published private(set) var layoutViewModel: CompanyLayoutViewModel?
    
    var cancellables = Set<AnyCancellable>()
    
    var dataSource: CompanyDataSourceProtocol
    
    init(dataSource: CompanyDataSourceProtocol = CompanyDataSource()) {
        self.dataSource = dataSource
    }
    
    
    func getCompany(completion: @escaping (Result<CompanyLayoutViewModel, ErrorResult>) -> Void) {
        self.loadState = .loading
        
        self.dataSource.getCompany { [weak self] result in
            switch result {
            case .success(let companyModel):
                guard let self else { return }
                self.layoutViewModel = CompanyLayoutViewModel(company: companyModel)
                
                self.loadState = .success(message: nil)
                    
                completion(.success(self.layoutViewModel!))
            case .failure(let error):
                guard let self else { return }
                
                self.loadState = .error(message: error.message)
                
                completion(.failure(error))
            }
        }
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
