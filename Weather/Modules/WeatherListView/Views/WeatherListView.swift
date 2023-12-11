//
//  CollectionView.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 09.12.2023.
//

import UIKit
import Combine

final class WeatherListView: UICollectionViewController {

    //MARK: - Public fields
    
    enum Section: Int, CaseIterable {
        case main
    }
    
    //MARK: - Private fields
    
    private let searchView: SearchView
    private let viewModel: WeatherListViewModelProtocol
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, WeatherListOutput>!
    
    private var cancelable = Set<AnyCancellable>()
    
    //MARK: - Initialaizers
    
    public init(searchView: SearchView, viewModel: WeatherListViewModelProtocol) {
        
        self.searchView = searchView
        self.viewModel = viewModel
        
        super.init(collectionViewLayout: .init())
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
        bind()
        
        viewModel.fetchData()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.didFinish()
    }
    
    //MARK: - Public methods
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        collectionView.isEditing = editing
        
    }
    
    //MARK: - Private methods
    
    private func configuration() {
        
        self.collectionView.backgroundColor = Resources.Colors.backgroundColor
        
        self.navigationItem.title = "Weather"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.hidesSearchBarWhenScrolling = true
        self.navigationItem.rightBarButtonItem = editButtonItem
        
        let searchController = UISearchController(searchResultsController: searchView)
        searchController.delegate = self
        self.navigationItem.searchController = searchController
        self.navigationItem.rightBarButtonItem?.tintColor = Resources.Colors.fontColor
        self.navigationItem.searchController?.searchResultsUpdater = searchView
        self.navigationItem.searchController?.searchBar.searchTextField.textColor = Resources.Colors.fontColor
        self.navigationItem.searchController?.searchBar.searchTextField.leftView?.tintColor = Resources.Colors.secondFontColor
        self.navigationItem.searchController?.searchBar.searchTextField.leftView?.tintColor = Resources.Colors.secondFontColor
        self.navigationItem.searchController?.searchBar.searchTextField.keyboardAppearance = .dark
        self.navigationItem.searchController?.searchBar.tintColor = Resources.Colors.fontColor
        self.navigationItem.searchController?.searchBar.barStyle = .black
        self.navigationItem.searchController?.searchBar.searchTextField.attributedPlaceholder = .some(.init(string: "Search", attributes: [.foregroundColor: Resources.Colors.secondFontColor ?? .white]))
        
        createDataSource()
        
        
        self.collectionView.dataSource = dataSource
        self.collectionView.collectionViewLayout = createLayout()
        
    }
    
    private func bind() {
        
        searchView.viewModel.selectedItem.sink { [unowned self] data in
            self.navigationItem.searchController?.isActive = false
            self.viewModel.fetchData()
        }.store(in: &cancelable)
        
        viewModel.refreshData.sink { [unowned self] _ in
            self.reloadShapshot()
        }.store(in: &cancelable)
        
        viewModel.error.sink { [unowned self] error in
            self.showAlert(message: error)
        }.store(in: &cancelable)
        
    }
    
    private func showAlert(message: String) {
        let view = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        
        view.addAction(action)
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        return .init { index, layoutEnviorement in
            guard let section = Section(rawValue: index) else { return nil }
            
            switch section {
            case .main:
                let item = NSCollectionLayoutItem(layoutSize:
                        .init(widthDimension: .fractionalWidth(1.0),
                              heightDimension: .fractionalHeight(1.0)))
                
                
                let group = NSCollectionLayoutGroup
                    .horizontal(layoutSize:
                            .init(widthDimension: .fractionalWidth(1.0),
                                  heightDimension: .absolute(100)),
                                subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
                section.interGroupSpacing = 20
            
                return section
                
            }
        }
        
    }
    
    private func createDataSource() {
        
        let cellRegistration = 
        UICollectionView.CellRegistration<WeatherListCell, WeatherListOutput> { [unowned self]
            (cell: WeatherListCell, indexPath, item: WeatherListOutput) in
            
            cell.update(data: item)
            
            let deleteButton = UICellAccessory.delete(displayed: .whenEditing) {

                guard let indexPath = self.dataSource.indexPath(for: item) else { return }
                
                if self.viewModel.deleteData(at: indexPath.row) {
                    self.deleteItem(item: item)
                }
                
            }
            
            cell.accessories = [deleteButton]
            
        }
        
        dataSource = .init(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, item in
            
            guard let section = Section(rawValue: indexPath.section) else {
                return UICollectionViewCell()
            }
            
            switch section {
            case.main:
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
                
                return cell
                
            }
        })
        
    }
    
    private func reloadShapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, WeatherListOutput>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.output)
        
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
    
    private func deleteItem(item: WeatherListOutput) {
        var shapshot = self.dataSource.snapshot()
        
        shapshot.deleteItems([item])
        
        dataSource.apply(shapshot, animatingDifferences: true)
        
        if viewModel.output.count == 0 {
            setEditing(false, animated: true)
        }
    }
    
}

//MARK: - CollectionViewDelegate implementation

extension WeatherListView {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if !collectionView.isEditing {
            
            viewModel.selectedItem.send(indexPath.row)
            
        }
        
    }
    
}

//MARK: - UISearchControllerDelegate

extension WeatherListView: UISearchControllerDelegate {
    
    public func willPresentSearchController(_ searchController: UISearchController) {
        
        self.setEditing(false, animated: true)
        
    }

}
