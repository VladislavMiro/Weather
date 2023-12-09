//
//  DayForecastView.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 02.12.2023.
//

import UIKit
import Combine

final class DayForecastView: UIView {

    //MARK: - Private fields
    
    private let label: UILabel = {
        let label = UILabel()
        
        label.text = "Day Forecast"
        label.textColor = Resources.Colors.secondFontColor
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layout.itemSize = CGSize(width: 115, height: 115)
        layout.scrollDirection = .horizontal
        
        view.collectionViewLayout = layout
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.register(DayForecastCell.self, forCellWithReuseIdentifier: DayForecastCell.cellIdentifier)
        view.backgroundColor = Resources.Colors.secondBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var cancelable = Set<AnyCancellable>()
    
    //MARK: - Public fields
    
    public let viewModel: DayForecastViewModelProtocol
    
    //MARK: - Initialaziers
    
    public init(viewModel: DayForecastViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        configure()
        constraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    
    private func configure() {
        backgroundColor = Resources.Colors.secondBackgroundColor
        layer.cornerRadius = 15
        self.clipsToBounds = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(label)
        addSubview(collectionView)
    }
    
    private func bind() {
        viewModel.refreshData.sink { [unowned self] _ in
            self.collectionView.reloadData()
        }.store(in: &cancelable)
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 5),
            label.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: label.layoutMarginsGuide.bottomAnchor, constant: 15),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 150),
            collectionView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            
            self.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

extension DayForecastView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayForecastCell.cellIdentifier, for: indexPath) as! DayForecastCell
        
        cell.setup(data: viewModel.output[indexPath.row])
        
        return cell
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.count
    }
    
}
