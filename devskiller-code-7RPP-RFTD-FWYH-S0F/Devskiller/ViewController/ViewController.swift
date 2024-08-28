//
//  ViewController.swift
//  Devskiller
//
//  Copyright © 2023 Mindera. All rights reserved.
//

import Foundation
import UIKit
import Combine

class ViewController: UIViewController, UITableViewDataSource {
    var companyViewModel: CompanyViewModel?
    var launchViewModel: LaunchViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    
    private enum Constants {
        static let headerdentifier = "HeaderCell"
        static let detailIdentifier = "DetailCell"
    }
    
    init(companyViewModel: CompanyViewModel = CompanyViewModel(), launchViewModel: LaunchViewModel = LaunchViewModel()) {
        self.companyViewModel = companyViewModel
        self.launchViewModel = launchViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupListeners()
        
        fetchData()
    }
    
    var tableView: UITableView = {
        var tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = .white
        tableView.backgroundColor = .tertiarySystemBackground
        
        tableView.rowHeight = UITableView.automaticDimension

        return tableView
    }()
    
    func loadViews() {
        view.addSubview(self.tableView)
        
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        tableView.register(HeaderCell.self, forCellReuseIdentifier: Constants.headerdentifier)
        tableView.register(DetailCell.self, forCellReuseIdentifier: Constants.detailIdentifier)
        
        self.tableView.dataSource = self
    }
    
    func fetchData() {
        
        /*companyViewModel?.getCompany(completion: { result in
            
            self.tableView.reloadData()
        })
        
        launchViewModel?.resetFilter()*/
    }
    
    func fetchLaunches(year: Int?, success: Bool?) {
        launchViewModel?.fetchLaunches(year: year, success: success)
    }
    
    func loadMore() {
        launchViewModel?.loadMore()
    }
    
    func setupListeners() {
        
        /*companyViewModel?.$layoutViewModel
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                
                switch completion {
                case .finished:
                    break
                case .failure:
                    break
                }
            }, receiveValue: { [weak self] result in
                guard let self else { return }
                
                self.tableView.reloadData()
            }).store(in: &self.cancellables)*/
        
        launchViewModel?.$layoutViewModels
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    break
                }
            }, receiveValue: { [weak self] result in
                guard let self else { return }
                
                self.tableView.reloadData()
                
            }).store(in: &self.cancellables)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        
        if section == 0 {
            rows = 1
        } else {
            rows = 10
        }
        
        print("tableView numberOfRowsInSection section \(section) rows \(rows)")
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("tableView cellForRowAt section \(indexPath.section) row \(indexPath.row)")
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.headerdentifier, for: indexPath) as? HeaderCell
            
            cell?.load(with: "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...")
            
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.detailIdentifier, for: indexPath) as? DetailCell
            cell?.load(with: "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...")
            return cell ?? UITableViewCell()
        }
    }
}
