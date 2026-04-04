//
//  SearchView.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 07.12.2023.
//

import UIKit
import Combine

final class SearchView: UITableViewController {

    //MARK: - Public properties
    
    public let viewModel: SearchViewModelProtocol
    
    //MARK: - Private properties

    private let cellIdentifire = StringConstants.cellIdentifire
    
    private var cancelable = Set<AnyCancellable>()
    
    //MARK: - Initialaizers
    
    public init(viewModel: SearchViewModelProtocol) {
        
        self.viewModel = viewModel
        
        super.init(style: .plain)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycles methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
        bind()
        
    }
    
}

//MARK: - Extension with UITableViewDataSource & UITableViewDelegate implementations

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

//MARK: - Extension with UISearchResultsUpdationg implementation

extension SearchView: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        guard !text.isEmpty else { return } 
        
        viewModel.searchText.send(text)
    }
    
}

//MARK: - Extension with private methods

private extension SearchView {
    
    func configuration() {
        self.tableView.backgroundColor = Colors.tableViewBackground
        self.clearsSelectionOnViewWillAppear = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifire)
        
        self.tableView.separatorColor = Colors.tableViewSeparator
        
    }
    
    func bind() {
        viewModel.refreshData.sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancelable)
        
        viewModel.error.sink { [weak self] error in
            self?.showAlert(message: error)
        }.store(in: &cancelable)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: StringConstants.errorTitle,
                                      message: message, preferredStyle: .alert)
        
        alert.addAction(.init(title: StringConstants.okButtonTitle,
                              style: .destructive, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func configureCell(cell: UITableViewCell, index: Int) -> UITableViewCell  {
        var configuration = cell.defaultContentConfiguration()
        
        configuration.text = viewModel.output[index].name
        configuration.secondaryText = viewModel.output[index].country
        configuration.textProperties.color = Colors.cellText ?? .black
        configuration.secondaryTextProperties.color = Colors.cellSecondaryText ?? .black
        
        cell.backgroundColor = Colors.background
        cell.contentConfiguration = configuration
        cell.selectionStyle = .none
        
        return cell
    }
   
}

//MARK: - Extension with private subobjects

private extension SearchView {
    
    enum StringConstants {
        static let cellIdentifire: String = "SearchViewCell"
        static let errorTitle: String = "Error"
        static let okButtonTitle: String = "OK"
    }
    
    enum Colors {
        static let background: UIColor? = R.color.backgroundColor()
        static let tableViewBackground: UIColor? = R.color.backgroundColor()
        static let tableViewSeparator: UIColor? = R.color.secondFontColor()
        static let cellText: UIColor? = R.color.fontColor()
        static let cellSecondaryText: UIColor? = R.color.fontColor()
    }
    
}
