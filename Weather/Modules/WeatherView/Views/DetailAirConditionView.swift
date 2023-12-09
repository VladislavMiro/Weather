//
//  DetailAirConditionView.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 03.12.2023.
//

import UIKit
import Combine

final class DetailAirConditionView: UICollectionViewController {
    
    //MARK: - Private fields
    
    private let header: HeaderView
    
    private let viewModel: DetailAirConditionViewModelProtocol
    private let headerIdentifier = "HeaderView"
    
    private var cancelable = Set<AnyCancellable>()

    //MARK: - Initializers
    
    public init(viewModel: DetailAirConditionViewModelProtocol , header: HeaderView) {
        self.viewModel = viewModel
        self.header = header
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: 150, height: 100)
        layout.sectionInset = .init(top: 10, left: 35, bottom: 10, right: 35)
        layout.headerReferenceSize = .init(width: UIScreen.main.bounds.width, height: 350)
        
        super.init(collectionViewLayout: layout)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        navigationItem.title = "Air Condition"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func bind() {
        viewModel.data.subscribe(header.viewModel.data).store(in: &cancelable)
        
        viewModel.output.sink { [unowned self] _ in
            self.collectionView.reloadData()
        }.store(in: &cancelable)
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
