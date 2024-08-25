//
//  ViewController.swift
//  Devskiller
//
//  Copyright © 2023 Mindera. All rights reserved.
//

import UIKit
import Combine

class ViewController: UIViewController {
    var companyViewModel: CompanyViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(companyViewModel: CompanyViewModel = CompanyViewModel()) {
        self.companyViewModel = companyViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func fetchCompany() {
        companyViewModel?.getCompany().sink { completion in
            switch completion {
            case .finished:
                print("ViewController: companyDataSource finished")
                ()
            case .failure(let error):
                print("ViewController: error \(error.message)")
            }
        } receiveValue: { company in
            print("ViewController: \(company.getString())")
        }.store(in: &self.cancellables)
    }
}

