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
    var launchViewModel: LaunchViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(companyViewModel: CompanyViewModel = CompanyViewModel(), launchViewModel: LaunchViewModel = LaunchViewModel()) {
        self.companyViewModel = companyViewModel
        self.launchViewModel = launchViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchCompany()
    }
    
    func fetchCompany() {
        /*companyViewModel?.getCompany().sink { completion in
            switch completion {
            case .finished:
                print("ViewController: fetchCompany finished")
                ()
            case .failure(let error):
                print("ViewController: fetchCompany error \(error.message)")
            }
        } receiveValue: { company in
            print("ViewController: fetchCompany \(company.getString())")
        }.store(in: &self.cancellables)*/
        
        launchViewModel?.fetchLaunches(filter: .default).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("ViewController: fetchLaunches finished")
                ()
            case .failure(let error):
                print("ViewController: fetchLaunches error \(error.message)")
            }
        }, receiveValue: { launches in
            launches.forEach({ print($0.getString()) })
        }).store(in: &self.cancellables)
    }
}

