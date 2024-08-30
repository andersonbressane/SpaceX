//
//  ViewController.swift
//  Devskiller
//
//  Copyright © 2023 Mindera. All rights reserved.
//

import Foundation
import UIKit
import Combine

class ViewController: UIViewController {
    
    let ORDER_DESCENDING = 0
    let ORDER_ASCENDING = 1
    
    let LAUNCH_SUCCESS = 1
    let LAUNCH_FAILURE = 2
    let LAUNCH_ALL = 0
    
    let SECTION_COMPANY = 0
    let SECTION_LAUNCHES = 1

    let YEAR_ALL = 0
    
    var companyViewModel: CompanyViewModelProtocol
    var launchViewModel: LaunchViewModelProtocol
    
    private enum Constants {
        static let headerdentifier = "HeaderCell"
        static let detailIdentifier = "DetailCell"
    }
    
    var fetchLaunchCompletion: (Result<Bool, ErrorResult>) -> Void = { _ in }
    
    init(companyViewModel: CompanyViewModelProtocol = CompanyViewModel(), launchViewModel: LaunchViewModelProtocol = LaunchViewModel()) {
        self.companyViewModel = companyViewModel
        self.launchViewModel = launchViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
     
    required init?(coder: NSCoder) {
        self.companyViewModel = CompanyViewModel()
        self.launchViewModel = LaunchViewModel()
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        self.loadViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
    }
    
    
    @IBOutlet weak var barButton: UIBarButtonItem!
    
    @IBAction func toggleSearchView(_ barButton: UIBarButtonItem) {
        toggleSearchView(shouldHide: !self.searchView.isHidden)
    }
    
    var tableView: UITableView = {
        var tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.rowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    var searchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiarySystemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowOffset = .init(width: 2, height: 2)
        view.layer.shadowOpacity = 0.2
        view.isHidden = true
        return view
    }()
    
    lazy var labelSearch: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Search Launch"
        return label
    }()
    
    lazy var labelYear: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Year:"
        return label
    }()
    
    lazy var textFieldYear: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.placeholder = "YYYY"
        return textField
    }()
    
    lazy var pickerYear: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.dataSource = self
        return picker
    }()
    
    lazy var labelOrder: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Order:"
        return label
    }()
    
    lazy var segmentedOrder: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Descening", "Ascending"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = ORDER_DESCENDING
        return segmentedControl
    }()
    
    lazy var labelSuccess: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Launch success: "
        return label
    }()
    
    lazy var segmentedSuccess: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["All", "Success", "Failure"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = LAUNCH_ALL
        return segmentedControl
    }()
    
    lazy var clearButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.tintColor = .link
        button.layer.cornerRadius = 8
        button.setTitle("Clear", for: .normal)
        return button
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .link
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.setTitle("Search", for: .normal)
        return button
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView.init(style: .medium)
        activityIndicator.tintColor = .label
        return activityIndicator
    }()
    
    var yearsArray: [Int] = {
        var years = [Int]()
        (YEAR_FOUNDED...YEAR_TODAY).forEach({ years.append($0)})
        return years
    }()
    
    var selectedYear: Int?
    
    func loadViews() {
        view.addSubview(self.tableView)
        
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        tableView.register(HeaderCell.self, forCellReuseIdentifier: Constants.headerdentifier)
        tableView.register(DetailCell.self, forCellReuseIdentifier: Constants.detailIdentifier)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        view.addSubview(self.searchView)
        self.searchView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.searchView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        self.searchView.addSubview(self.labelSearch)
        self.labelSearch.topAnchor.constraint(equalTo: self.searchView.topAnchor, constant: 16).isActive = true
        self.labelSearch.leadingAnchor.constraint(equalTo: self.searchView.leadingAnchor, constant: 16).isActive = true
        self.labelSearch.trailingAnchor.constraint(equalTo: self.searchView.trailingAnchor, constant: -16).isActive = true
        
        self.searchView.addSubview(self.labelYear)
        self.labelYear.topAnchor.constraint(equalTo: self.labelSearch.bottomAnchor, constant: 16).isActive = true
        self.labelYear.leadingAnchor.constraint(equalTo: self.searchView.leadingAnchor, constant: 16).isActive = true
        self.labelYear.trailingAnchor.constraint(equalTo: self.searchView.trailingAnchor, constant: -16).isActive = true
        
        self.searchView.addSubview(self.pickerYear)
        self.pickerYear.topAnchor.constraint(equalTo: self.labelYear.bottomAnchor, constant: 8).isActive = true
        self.pickerYear.leadingAnchor.constraint(equalTo: self.searchView.leadingAnchor, constant: 16).isActive = true
        self.pickerYear.trailingAnchor.constraint(equalTo: self.searchView.trailingAnchor, constant: -16).isActive = true
        
        self.pickerYear.delegate = self
        self.pickerYear.dataSource = self
        
        self.searchView.addSubview(self.labelOrder)
        self.labelOrder.topAnchor.constraint(equalTo: self.pickerYear.bottomAnchor, constant: 16).isActive = true
        self.labelOrder.leadingAnchor.constraint(equalTo: self.searchView.leadingAnchor, constant: 16).isActive = true
        self.labelOrder.trailingAnchor.constraint(equalTo: self.searchView.trailingAnchor, constant: -16).isActive = true
        
        self.searchView.addSubview(self.segmentedOrder)
        self.segmentedOrder.topAnchor.constraint(equalTo: self.labelOrder.bottomAnchor, constant: 8).isActive = true
        self.segmentedOrder.leadingAnchor.constraint(equalTo: self.searchView.leadingAnchor, constant: 16).isActive = true
        self.segmentedOrder.trailingAnchor.constraint(equalTo: self.searchView.trailingAnchor, constant: -16).isActive = true
        
        self.searchView.addSubview(self.labelSuccess)
        self.labelSuccess.topAnchor.constraint(equalTo: self.segmentedOrder.bottomAnchor, constant: 24).isActive = true
        self.labelSuccess.leadingAnchor.constraint(equalTo: self.searchView.leadingAnchor, constant: 16).isActive = true
        self.labelSuccess.trailingAnchor.constraint(equalTo: self.searchView.trailingAnchor, constant: -16).isActive = true
        
        self.searchView.addSubview(self.segmentedSuccess)
        self.segmentedSuccess.topAnchor.constraint(equalTo: self.labelSuccess.bottomAnchor, constant: 8).isActive = true
        self.segmentedSuccess.leadingAnchor.constraint(equalTo: self.searchView.leadingAnchor, constant: 16).isActive = true
        self.segmentedSuccess.trailingAnchor.constraint(equalTo: self.searchView.trailingAnchor, constant: -16).isActive = true
        
        self.searchView.addSubview(self.clearButton)
        self.clearButton.topAnchor.constraint(equalTo: self.segmentedSuccess.bottomAnchor, constant: 24).isActive = true
        self.clearButton.leadingAnchor.constraint(equalTo: self.searchView.leadingAnchor, constant: 16).isActive = true
        self.clearButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.clearButton.bottomAnchor.constraint(equalTo: self.searchView.bottomAnchor, constant: -16).isActive = true
        self.clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        
        self.searchView.addSubview(self.searchButton)
        self.searchButton.topAnchor.constraint(equalTo: self.segmentedSuccess.bottomAnchor, constant: 24).isActive = true
        self.searchButton.leadingAnchor.constraint(equalTo: self.clearButton.trailingAnchor, constant: 16).isActive = true
        self.searchButton.trailingAnchor.constraint(equalTo: self.searchView.trailingAnchor, constant: -16).isActive = true
        self.searchButton.bottomAnchor.constraint(equalTo: self.searchView.bottomAnchor, constant: -16).isActive = true
        self.searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activityIndicator)
    }
    
    func toggleSearchView(shouldHide: Bool) {
        barButton.image = UIImage(systemName: shouldHide ? "magnifyingglass.circle" : "magnifyingglass.circle.fill")
        
        searchView.isHidden = shouldHide
    }
    
    @objc func search() {
        toggleSearchView(shouldHide: true)
        
        activityIndicator.startAnimating()
        
        self.launchViewModel.fetchLaunches(
            year: self.selectedYear,
            success: self.segmentedSuccess.selectedSegmentIndex == LAUNCH_SUCCESS ? true : self.segmentedSuccess.selectedSegmentIndex == LAUNCH_FAILURE ? false : nil,
            order: self.segmentedOrder.selectedSegmentIndex == ORDER_DESCENDING ? .desc : .asc, completion: fetchLaunchCompletion)
        
        self.tableView.reloadData()
    }
    
    @objc func clear() {
        toggleSearchView(shouldHide: true)
        
        activityIndicator.startAnimating()
        
        self.segmentedSuccess.selectedSegmentIndex = LAUNCH_ALL
        self.segmentedOrder.selectedSegmentIndex = ORDER_DESCENDING
        self.pickerYear.selectRow(YEAR_ALL, inComponent: 0, animated: true)
        
        self.launchViewModel.resetFilter(completion: fetchLaunchCompletion)
        self.tableView.reloadData()
    }
    
    func fetchData() {
        activityIndicator.startAnimating()
        
        fetchCompany()
        fetchLaunches()
    }
    
    func fetchCompany() {
        companyViewModel.getCompany { [weak self] result in
            guard let self else { return }
            
            self.activityIndicator.stopAnimating()
            
            switch result {
            case .success:
                self.tableView.reloadData()
                
            case .failure(let failure):
                print(failure.message)
            }
        }
    }
    
    func fetchLaunches() {
        activityIndicator.startAnimating()
        
        fetchLaunchCompletion = { [weak self] result in
            guard let self else { return }
            
            self.activityIndicator.stopAnimating()
            
            switch result {
            case .success(_):
                self.tableView.reloadData()
            case .failure(let failure):
                print(failure.message)
                let alert = UIAlertController(title: "Attention", message: failure.message, preferredStyle: .alert)
                alert.addAction(.init(title: "Ok", style: .default))
                self.present(alert, animated: true)
            }
        }
        
        launchViewModel.fetchLaunches(.default, completion: fetchLaunchCompletion)
    }
    
    func fetchMore() {
        activityIndicator.startAnimating()
        
        launchViewModel.fetchMore(completion: fetchLaunchCompletion)
    }
    
    func openLink(url: URL?) {
        guard let url = url, UIApplication.shared.canOpenURL(url) else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SECTION_COMPANY {
            return 1
        } else {
            return self.launchViewModel.layoutViewModels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_COMPANY {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.headerdentifier, for: indexPath) as? HeaderCell
            
            cell?.load(with: companyViewModel.layoutViewModel?.getString() ?? "")
            
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.detailIdentifier, for: indexPath) as? DetailCell
            
            cell?.load(with: launchViewModel.layoutViewModels[indexPath.row])
            
            if (indexPath.row == launchViewModel.layoutViewModels.count - INDEX_TO_LOAD_MORE) {
                self.fetchMore()
            }
            
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_LAUNCHES {
            return self.launchViewModel.layoutViewModels[indexPath.row].hasLink
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == SECTION_LAUNCHES {
            let layoutViewModel = launchViewModel.layoutViewModels[indexPath.row]
            
            if layoutViewModel.hasLink {
                let alertController = UIAlertController(title: "Launch", message: layoutViewModel.missionName, preferredStyle: .actionSheet)
                
                if let articleURL = layoutViewModel.articleURL {
                    alertController.addAction(.init(title: "Article", style: .default, handler: { [weak self] _ in
                        guard let self = self else { return }
                        self.openLink(url: articleURL)
                    }))
                }
                
                if let wikiPediaURL = layoutViewModel.wikiPediaURL {
                    alertController.addAction(.init(title: "Wikipedia", style: .default, handler: { [weak self] _ in
                        guard let self = self else { return }
                        self.openLink(url: wikiPediaURL)
                    }))
                }
                
                if let webCastURL = layoutViewModel.webCastURL {
                    alertController.addAction(.init(title: "Webcast", style: .default, handler: { [weak self] _ in
                        guard let self = self else { return }
                        self.openLink(url: webCastURL)
                    }))
                }
                
                alertController.addAction(.init(title: "Cancel", style: .cancel))
                
                self.present(alertController, animated: true)
            }
        }
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearsArray.count + 1
    }
 
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row == YEAR_ALL ? "All" : "\(yearsArray[row - 1])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedYear = row == YEAR_ALL ? nil : yearsArray[row - 1]
    }
}
