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
        enum Cell {
            static let launchCellIdentifier = "LaunchTableViewCell"
        }
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
        
        self.setupListeners()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        launchViewModel?.fetchLaunches(nil)
    }
    
    func setupListeners() {
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
                
                print("\nlasResult: \(result.last?.getString())")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.launchViewModel?.loadMore()
                }
                
                self.tableView.reloadData()
            }).store(in: &self.cancellables)
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
        
        tableView.register(UINib(nibName: Constants.Cell.launchCellIdentifier, bundle: nil), forCellReuseIdentifier: Constants.Cell.launchCellIdentifier)
        
        self.tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("tableView numberOfSections 1")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView numberOfRowsInSection \(self.launchViewModel?.layoutViewModels.count ?? 0)")
        return self.launchViewModel?.layoutViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("tableView cellForRowAt section \(indexPath.section) row \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.launchCellIdentifier)
        
        cell?.textLabel?.text = self.launchViewModel?.layoutViewModels[indexPath.row].getString()
        
        return cell ?? UITableViewCell()
    }
}
