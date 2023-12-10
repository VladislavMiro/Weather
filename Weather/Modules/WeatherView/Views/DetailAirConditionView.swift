//
//  DetailAirConditionView.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 03.12.2023.
//

import UIKit
import Combine

final class DetailAirConditionView: UICollectionViewController {
    
    //MARK: - Public fields
    
    typealias Output = DetailAirConditionDataModel.AirConditionCellOutputData
    
    enum Section: Int, CaseIterable {
        case main
    }
    
    //MARK: - Private fields
    
    private let header: HeaderView
    
    private let viewModel: DetailAirConditionViewModelProtocol
    private let headerIdentifier = "HeaderView"
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Output>!
    
    private var cancelable = Set<AnyCancellable>()

    //MARK: - Initializers
    
    public init(viewModel: DetailAirConditionViewModelProtocol , header: HeaderView) {
        self.viewModel = viewModel
        self.header = header
        
        super.init(collectionViewLayout: .init())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.finish()
    }

    //MARK: - Private methods
    
    private func configure() {
        collectionView.register(AirConditionCell.self, forCellWithReuseIdentifier: AirConditionCell.cellReuseIdentifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.backgroundColor = Resources.Colors.backgroundColor
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = false
        
        collectionView.collectionViewLayout = makeCollectionViewLayout()
        
        navigationItem.title = "Air Condition"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func bind() {
        viewModel.data.subscribe(header.viewModel.data).store(in: &cancelable)
        
        viewModel.output.sink { [unowned self] _ in
            self.collectionView.reloadData()
        }.store(in: &cancelable)
    }
    
    private func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return .init { index, layoutEnviorement in
            guard let section = Section(rawValue: index) else { return nil }
            
            switch section {
            case .main:
                let item = NSCollectionLayoutItem(layoutSize:
                        .init(widthDimension: .fractionalWidth(0.5),
                              heightDimension: .fractionalHeight(1.0)))
                
                item.contentInsets = .init(top: 0,
                                           leading: 5,
                                           bottom: 0,
                                           trailing: 5)
                
                let group = NSCollectionLayoutGroup
                    .horizontal(layoutSize:
                            .init(widthDimension: .fractionalWidth(1.0),
                                  heightDimension: .estimated(125)),
                                subitems: [item, item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(350))
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
                
                section.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
                section.interGroupSpacing = 20
                section.boundarySupplementaryItems = [header]
            
                return section
                
            }
        }
    }
    
}

//MARK: - CollectionViewDataSource & Delegate 

extension DetailAirConditionView {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.value.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AirConditionCell.cellReuseIdentifier, for: indexPath) as! AirConditionCell
        
        cell.setup(data: viewModel.output.value[indexPath.row])
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath)
        
        header.frame = headerView.bounds
        headerView.addSubview(header)
        
        return headerView
    }
    
}
