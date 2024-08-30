//
//  CompanyViewModel.swift
//  Devskiller
//
//  Created by Anderson Franco on 25/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

protocol CompanyViewModelProtocol: ViewModelProtocol {
    func getCompany(completion: @escaping (Result<CompanyLayoutViewModel, ErrorResult>) -> Void)
    
    var layoutViewModel: CompanyLayoutViewModel? { get }
}

class CompanyViewModel: CompanyViewModelProtocol {
    var layoutViewModel: CompanyLayoutViewModel?
    
    var loadState: LoadState = .none
    
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
                
                self.loadState = .success(message: nil)
                
                self.layoutViewModel = CompanyLayoutViewModel(company: companyModel)
                
                completion(.success(CompanyLayoutViewModel(company: companyModel)))
            case .failure(let error):
                guard let self else { return }
                
                self.loadState = .error(message: error.message)
                
                completion(.failure(error))
            }
        }
    }
}
