//
//  CompanyViewModelTests.swift
//  DevskillerTests
//
//  Created by Anderson Franco on 30/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import XCTest
@testable import Devskiller

final class CompanyViewModelTests: XCTestCase {
    func testGetCompanySuccess() {
        let viewModel = MockCompanyViewModelSuccess()
        let expectation = self.expectation(description: "Load layout model")
        
        viewModel.getCompany { result in
            switch result {
            case .success(let model):
                XCTAssertEqual(model.name, "SpaceX")
                XCTAssertEqual(model.founderName, "Elon Musk")
                XCTAssertEqual(model.foundedYear, 2002)
                XCTAssertEqual(model.employees, 8000)
                XCTAssertEqual(model.lauchSites, 3)
                XCTAssertEqual(model.valuation, 1000000000)
                
            case .failure(_):
                XCTFail("Expected success but failed")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetCompanyFail() {
        let viewModel = MockCompanyViewModelFail()
        let expectation = self.expectation(description: "Load layout model")
        
        viewModel.getCompany { result in
            switch result {
            case .success(_):
                XCTFail("Expected fail but success")
            case .failure(let error):
                XCTAssertEqual(error.message, "No data resonse")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

class MockCompanyViewModelSuccess: CompanyDataSourceProtocol {
    
    let company = Company(name: "SpaceX", founderName: "Elon Musk", foundedYear: 2002, employees: 8000, lauchSites: 3, valuation: 1000000000)
    
    func getCompany(completion: @escaping (Result<Company, Devskiller.ErrorResult>) -> Void) {
        return completion(.success(company))
    }
}

class MockCompanyViewModelFail: CompanyDataSourceProtocol {
    func getCompany(completion: @escaping (Result<Company, Devskiller.ErrorResult>) -> Void) {
        return completion(.failure(.noData))
    }
}
