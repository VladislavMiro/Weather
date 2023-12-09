//
//  CollectionView.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 09.12.2023.
//

import UIKit
import Combine

final class WeatherListView: UICollectionViewController {

    enum Section: Int, CaseIterable {
        case table
    }
    
    private let searchView: SearchView
    private let viewModel: WeatherListViewModelProtocol
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, WeatherListOutput>!
    
    
    private var cancelable = Set<AnyCancellable>()
    
    public init(searchView: SearchView, viewModel: WeatherListViewModelProtocol) {
        self.searchView = searchView
        self.viewModel = viewModel
        super.init(collectionViewLayout: .init())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
        bind()
        viewModel.fetchData()
    }
    
    private func configuration() {
        self.collectionView.backgroundColor = Resources.Colors.backgroundColor
        
        self.collectionView!.register(WeatherListCell.self, forCellWithReuseIdentifier: WeatherListCell.cellIdentifire)
        
        self.navigationItem.title = "Weather"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = UISearchController(searchResultsController: searchView)
        self.navigationItem.searchController?.searchResultsUpdater = searchView
        self.navigationController?.navigationItem.hidesSearchBarWhenScrolling = true
        
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
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        return .init { index, layoutEnviorement in
            guard let section = Section(rawValue: index) else { return nil }
            
            switch section {
            case .table:
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
        dataSource = .init(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, item in
            
            guard let section = Section(rawValue: indexPath.section) else {
                return UICollectionViewCell()
            }
            
            switch section {
            case.table:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherListCell.cellIdentifire, for: indexPath) as! WeatherListCell
                
                cell.update(data: item)
                
                return cell
            }
        })
    }
    
    private func reloadShapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, WeatherListOutput>()
        
        snapshot.appendSections([.table])
        snapshot.appendItems(viewModel.output, toSection: .table)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedItem.send(indexPath.row)
    }
    
}
