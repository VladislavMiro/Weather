//
//  DayForecastView.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 02.12.2023.
//

import UIKit
import Combine
import SnapKit

final class DayForecastView: UIView {

    //MARK: - Private properties
    
    private let label: UILabel = {
        let label = UILabel()
        
        label.text = StringConstants.label
        label.textColor = Resources.Colors.secondFontColor
        label.textAlignment = .left
        label.font = Fonts.title
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: LayoutConstants.sectionVerticalInset,
                                           left: LayoutConstants.sectionHorizontalInset,
                                           bottom: LayoutConstants.sectionVerticalInset,
                                           right: LayoutConstants.sectionHorizontalInset)
        layout.itemSize = CGSize(width: LayoutConstants.collectionViewItemSize,
                                 height: LayoutConstants.collectionViewItemSize)
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
    
    //MARK: - Public properties
    
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
    
}

//MARK: - Extension with UICollectionViewDelegate & UICollectionViewDataSource implementations

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

//MARK: - Extension with private methods

private extension DayForecastView {
    
    func configure() {
        backgroundColor = Resources.Colors.secondBackgroundColor
        layer.cornerRadius = LayoutConstants.superViewCornerRadius
        self.clipsToBounds = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(label)
        addSubview(collectionView)
    }
    
    func bind() {
        viewModel.refreshData.sink { [unowned self] _ in
            self.collectionView.reloadData()
        }.store(in: &cancelable)
    }
    
    func constraints() {
        
        self.snp.makeConstraints {
            $0.height.equalTo(LayoutConstants.superViewHeight)
        }
        
        label.snp.makeConstraints {
            $0.top.equalToSuperview()
                .offset(LayoutConstants.labelTopOffset)
            $0.leading.equalToSuperview()
                .offset(LayoutConstants.labelLeadingOffset)
            $0.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom)
                .offset(LayoutConstants.collectionViewTopOffset)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(LayoutConstants.collectionViewHeight)
        }

    }
    
}

//MARK: - Extension with private subobjects

private extension DayForecastView {
    
    enum LayoutConstants {
        static let labelTopOffset: CGFloat = 5.0
        static let labelLeadingOffset: CGFloat = 15.0
        static let collectionViewTopOffset: CGFloat = 15.0
        static let collectionViewHeight: CGFloat = 150.0
        static let superViewHeight: CGFloat = 200.0
        static let superViewCornerRadius: CGFloat = 15.0
        static let sectionVerticalInset: CGFloat = 10.0
        static let sectionHorizontalInset: CGFloat = 15.0
        static let collectionViewItemSize: CGFloat = 115.0
    }
    
    enum Fonts {
        static let title: UIFont = .boldSystemFont(ofSize: 16)
    }
    
    enum StringConstants {
        static let label: String = "Day Forecast"
    }
    
}
