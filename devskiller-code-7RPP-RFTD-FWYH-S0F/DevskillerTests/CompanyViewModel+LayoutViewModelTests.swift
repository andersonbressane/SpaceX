//
//  CompanyViewModel+LayoutViewModelTests.swift
//  DevskillerTests
//
//  Created by Anderson Franco on 30/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import XCTest
@testable import Devskiller

final class CompanyViewModel_LayoutViewModelTests: XCTestCase {
    func testName() {
        let company = Company(name: "SpaceX", founderName: "Elon Musk", foundedYear: 2002, employees: 8000, lauchSites: 3, valuation: 1000000000)
        let viewModel = CompanyLayoutViewModel(company: company)
        
        XCTAssertEqual(viewModel.name, "SpaceX")
    }

    func testFounder() {
        let company = Company(name: "SpaceX", founderName: "Elon Musk", foundedYear: 2002, employees: 8000, lauchSites: 3, valuation: 1000000000)
        let viewModel = CompanyLayoutViewModel(company: company)
        
        XCTAssertEqual(viewModel.founder, "Elon Musk")
    }

    func testFoundedYear() {
        let company = Company(name: "SpaceX", founderName: "Elon Musk", foundedYear: 2002, employees: 8000, lauchSites: 3, valuation: 1000000000)
        let viewModel = CompanyLayoutViewModel(company: company)
        
        XCTAssertEqual(viewModel.foundedYear, 2002)
    }

    func testEmployeesWithNonNilValue() {
        let company = Company(name: "SpaceX", founderName: "Elon Musk", foundedYear: 2002, employees: 8000, lauchSites: 3, valuation: 1000000000)
        let viewModel = CompanyLayoutViewModel(company: company)
        
        XCTAssertEqual(viewModel.employees, 8000)
    }

    func testEmployeesWithNilValue() {
        let company = Company(name: "SpaceX", founderName: "Elon Musk", foundedYear: 2002, employees: nil, lauchSites: 3, valuation: 1000000000)
        let viewModel = CompanyLayoutViewModel(company: company)
        
        XCTAssertEqual(viewModel.employees, 0)
    }

    func testLaunchSitesWithNonNilValue() {
        let company = Company(name: "SpaceX", founderName: "Elon Musk", foundedYear: 2002, employees: 8000, lauchSites: 3, valuation: 1000000000)
        let viewModel = CompanyLayoutViewModel(company: company)
        
        XCTAssertEqual(viewModel.launchSites, 3)
    }

    func testLaunchSitesWithNilValue() {
        let company = Company(name: "SpaceX", founderName: "Elon Musk", foundedYear: 2002, employees: 8000, lauchSites: nil, valuation: 1000000000)
        let viewModel = CompanyLayoutViewModel(company: company)
        
        XCTAssertEqual(viewModel.launchSites, 0)
    }

    func testValuationWithNonNilValue() {
        let company = Company(name: "SpaceX", founderName: "Elon Musk", foundedYear: 2002, employees: 8000, lauchSites: 3, valuation: 1000000000)
        let viewModel = CompanyLayoutViewModel(company: company)
        
        XCTAssertEqual(viewModel.valuation, 1000000000)
    }

    func testValuationWithNilValue() {
        let company = Company(name: "SpaceX", founderName: "Elon Musk", foundedYear: 2002, employees: 8000, lauchSites: 3, valuation: nil)
        let viewModel = CompanyLayoutViewModel(company: company)
        
        XCTAssertEqual(viewModel.valuation, 0.0)
    }

    func testValuationStringWithNonNilValue() {
        let company = Company(name: "SpaceX", founderName: "Elon Musk", foundedYear: 2002, employees: 8000, lauchSites: 3, valuation: 100000000000)
        let viewModel = CompanyLayoutViewModel(company: company)
        
        XCTAssertEqual(viewModel.valuationString, "100000000000")
    }

    func testValuationStringWithNilValue() {
        let company = Company(name: "SpaceX", founderName: "Elon Musk", foundedYear: 2002, employees: 8000, lauchSites: 3, valuation: nil)
        let viewModel = CompanyLayoutViewModel(company: company)
        
        XCTAssertEqual(viewModel.valuationString, "0")
    }

    func testGetString() {
        let company = Company(name: "SpaceX", founderName: "Elon Musk", foundedYear: 2002, employees: 8000, lauchSites: 3, valuation: 1000000000)
        let viewModel = CompanyLayoutViewModel(company: company)
        
        let expectedString = "SpaceX was founded by Elon Musk in 2002. It has now 8000 employees, 3 launch sites, and is valued at USD 1000000000"
        XCTAssertEqual(viewModel.getString(), expectedString)
    }
}
