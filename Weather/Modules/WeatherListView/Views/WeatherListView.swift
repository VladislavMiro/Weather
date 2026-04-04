//
//  CollectionView.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 09.12.2023.
//

import UIKit
import Combine

final class WeatherListView: UICollectionViewController {
    
    //MARK: - Private properties
    
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
    
    //MARK: - Life cycle methods
    
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
    
    //MARK: - Overriden methods
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        collectionView.isEditing = editing
        
    }
    
}

//MARK: - Extension wit CollectionViewDelegate & CollectionViewDataSource  implementations

extension WeatherListView {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if !collectionView.isEditing {
            
            viewModel.selectedItem.send(indexPath.row)
            
        }
        
    }
    
}

//MARK: - Extension with UISearchControllerDelegate implementations

extension WeatherListView: UISearchControllerDelegate {
    
    public func willPresentSearchController(_ searchController: UISearchController) {
        
        self.setEditing(false, animated: true)
        
    }

}

//MARK: - Extension with private methods

private extension WeatherListView {
    
    func configuration() {
        
        self.collectionView.backgroundColor = Resources.Colors.backgroundColor
        
        self.navigationItem.title = StringConstants.navigationViewTitle
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
        self.navigationItem.searchController?.searchBar.searchTextField
            .attributedPlaceholder = .some(.init(string: StringConstants.searchControllerPlaceholder,
                                                 attributes: [
                                                    .foregroundColor: Resources.Colors.secondFontColor ?? .white
                                                 ]))
        
        createDataSource()
        
        
        self.collectionView.dataSource = dataSource
        self.collectionView.collectionViewLayout = createLayout()
        
    }
    
    func bind() {
        
        searchView.viewModel.selectedItem.sink { [weak self] data in
            self?.navigationItem.searchController?.isActive = false
            self?.viewModel.fetchData()
        }.store(in: &cancelable)
        
        viewModel.refreshData.sink { [weak self] _ in
            self?.reloadShapshot()
        }.store(in: &cancelable)
        
        viewModel.error.sink { [weak self] error in
            self?.showAlert(message: error)
        }.store(in: &cancelable)
        
    }
    
    func showAlert(message: String) {
        let view = UIAlertController(title: StringConstants.errorTitle, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: StringConstants.okButtonTitle, style: .default)
        
        view.addAction(action)
    }

    func createLayout() -> UICollectionViewCompositionalLayout {
        
        return .init { index, layoutEnviorement in
            guard let section = Section(rawValue: index) else { return nil }
            
            switch section {
            case .main:
                let item = NSCollectionLayoutItem(layoutSize:
                        .init(widthDimension: .fractionalWidth(LayoutConstants.itemWidth),
                              heightDimension: .fractionalHeight(LayoutConstants.itemHeight)))
                
                
                let group = NSCollectionLayoutGroup
                    .horizontal(layoutSize:
                            .init(widthDimension: .fractionalWidth(LayoutConstants.groupWidth),
                                  heightDimension: .absolute(LayoutConstants.groupHeight)),
                                subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets = .init(top: LayoutConstants.sectionVerticalContentInset,
                                              leading: LayoutConstants.sectionHorizontalContentInset,
                                              bottom: LayoutConstants.sectionVerticalContentInset,
                                              trailing: LayoutConstants.sectionHorizontalContentInset)
                section.interGroupSpacing = LayoutConstants.interGroupSpacing
            
                return section
                
            }
        }
        
    }
    
    func createDataSource() {
        
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
    
    func reloadShapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, WeatherListOutput>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.output)
        
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
    
    func deleteItem(item: WeatherListOutput) {
        var shapshot = self.dataSource.snapshot()
        
        shapshot.deleteItems([item])
        
        dataSource.apply(shapshot, animatingDifferences: true)
        
        if viewModel.output.count == 0 {
            setEditing(false, animated: true)
        }
    }
   
}

//MARK: - Extension with private subobjects

private extension WeatherListView {
    
    enum LayoutConstants {
        static let itemWidth: CGFloat = 1.0
        static let itemHeight: CGFloat = 1.0
        static let groupWidth: CGFloat = 1.0
        static let groupHeight: CGFloat = 100.0
        static let sectionVerticalContentInset: CGFloat = 10.0
        static let sectionHorizontalContentInset: CGFloat = 20.0
        static let interGroupSpacing: CGFloat = 20.0
    }
    
    enum StringConstants {
        static let navigationViewTitle: String = "Weather"
        static let errorTitle: String = "Error"
        static let okButtonTitle: String = "OK"
        static let searchControllerPlaceholder: String = "Search"
    }
    
    enum Section: Int, CaseIterable {
        case main
    }
    
}



