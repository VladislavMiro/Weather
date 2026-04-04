//
//  DetailAirConditionView.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 03.12.2023.
//

import UIKit
import Combine

final class DetailAirConditionView: UICollectionViewController {
    
    //MARK: - Public properties
    
    typealias Output = DetailAirConditionDataModel.AirConditionCellOutputData
    
    //MARK: - Private properties
    
    private let header: HeaderView
    private let viewModel: DetailAirConditionViewModelProtocol
    
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
    
    //MARK: - Life Cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.finish()
    }
    
}

//MARK: - Extension with CollectionViewDataSource & CollectionViewDelegate implementations

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
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: StringConstants.headerIdentifier,
                                                                         for: indexPath)
        
        header.frame = headerView.bounds
        headerView.addSubview(header)
        
        return headerView
    }
    
}

//MARK: - Extension with private methods

private extension DetailAirConditionView {
    
    func configure() {
        collectionView.register(AirConditionCell.self, forCellWithReuseIdentifier: AirConditionCell.cellReuseIdentifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StringConstants.headerIdentifier)
        collectionView.backgroundColor = Colors.collectionViewBackground
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = false
        
        collectionView.collectionViewLayout = makeCollectionViewLayout()
        
        navigationItem.title = StringConstants.navigationViewTitle
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func bind() {
        viewModel.data
            .subscribe(header.viewModel.data)
            .store(in: &cancelable)
        
        viewModel.output.sink { [weak self] _ in
            self?.collectionView.reloadData()
        }.store(in: &cancelable)
    }
    
    func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return .init { index, layoutEnviorement in
            guard let section = Section(rawValue: index) else { return nil }
            
            switch section {
            case .main:
                let item = NSCollectionLayoutItem(layoutSize:
                        .init(widthDimension: .fractionalWidth(LayoutConstants.itemWidth),
                              heightDimension: .fractionalHeight(LayoutConstants.itemHeight)))
                
                item.contentInsets = .init(top: LayoutConstants.itemVerticalContentInset,
                                           leading: LayoutConstants.itemHorizontalContentInset,
                                           bottom: LayoutConstants.itemVerticalContentInset,
                                           trailing: LayoutConstants.itemHorizontalContentInset)
                
                let group = NSCollectionLayoutGroup
                    .horizontal(layoutSize:
                            .init(widthDimension: .fractionalWidth(LayoutConstants.groupWidth),
                                  heightDimension: .estimated(LayoutConstants.groupHeight)),
                                subitems: [item, item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(LayoutConstants.headerWidth),
                    heightDimension: .absolute(LayoutConstants.headerHeight))
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
                
                section.contentInsets = .init(top: LayoutConstants.sectionVerticalContentInset,
                                              leading: LayoutConstants.sectionHorizontalContentInset,
                                              bottom: LayoutConstants.sectionVerticalContentInset,
                                              trailing: LayoutConstants.sectionHorizontalContentInset)
                section.interGroupSpacing = LayoutConstants.interGroupSpacing
                section.boundarySupplementaryItems = [header]
            
                return section
                
            }
        }
    }
}

//MARK: - Extension with private subobjects

private extension DetailAirConditionView {
    
    enum LayoutConstants {
        static let itemWidth: CGFloat = 0.5
        static let itemHeight: CGFloat = 1.0
        static let itemVerticalContentInset: CGFloat = 0.0
        static let itemHorizontalContentInset: CGFloat = 5.0
        static let groupWidth: CGFloat = 1.0
        static let groupHeight: CGFloat = 125.0
        static let headerWidth: CGFloat = 1.0
        static let headerHeight: CGFloat = 350
        static let sectionVerticalContentInset: CGFloat = 10.0
        static let sectionHorizontalContentInset: CGFloat = 20.0
        static let interGroupSpacing: CGFloat = 20.0
    }
    
    enum StringConstants {
        static let navigationViewTitle: String = "Air condition"
        static let headerIdentifier: String = "HeaderView"
    }
    
    enum Section: Int, CaseIterable {
        case main
    }
    
    enum Colors {
        static let collectionViewBackground: UIColor? = R.color.backgroundColor()
    }
    
}
