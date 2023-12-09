//
//  SearchView.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 07.12.2023.
//

import UIKit
import Combine

final class SearchView: UITableViewController {

    //MARK: - Public fields
    
    public let viewModel: SearchViewModelProtocol
    
    //MARK: - Private fields

    private let cellIdentifire = "SearchViewCell"
    
    private var cancelable = Set<AnyCancellable>()
    
    //MARK: - Initialaizers
    
    public init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
        bind()
    }
    
    //MARK: - Private methods
    
    private func configuration() {
        self.tableView.backgroundColor = Resources.Colors.backgroundColor
        self.clearsSelectionOnViewWillAppear = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifire)
    }
    
    private func bind() {
        viewModel.refreshData.sink { [unowned self] _ in
            self.tableView.reloadData()
        }.store(in: &cancelable)
        
        viewModel.error.sink { [unowned self] error in
            self.showAlert(message: error)
        }.store(in: &cancelable)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        alert.addAction(.init(title: "OK", style: .destructive, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    private func configureCell(cell: UITableViewCell, index: Int) -> UITableViewCell  {
        var configuration = cell.defaultContentConfiguration()
        
        configuration.text = viewModel.output[index].name
        configuration.secondaryText = viewModel.output[index].country
        
        cell.backgroundColor = Resources.Colors.backgroundColor
        cell.contentConfiguration = configuration
        
        return cell
    }
    
}

//MARK: - UITableViewDataSource & UITableViewDelegate implementation

extension SearchView {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath)
        
        cell = configureCell(cell: cell, index: indexPath.row)
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectionItem.send(indexPath.row)
    }
    
}

//MARK: - UISearchResultsUpdationg implementation

extension SearchView: UISearchResultsUpdating, UISearchControllerDelegate {
    
    public func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        guard !text.isEmpty else { return } 
        
        viewModel.searchText.send(text)
    }
    
}
