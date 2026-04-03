//
//  DayForecastCell.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 02.12.2023.
//

import UIKit
import Combine

final class DayForecastCell: UICollectionViewCell {
    
    //MARK: - Public properties
    
    typealias OutputData = WeatherViewDataModels.DayForecastCellOutputData
    
    public static let cellIdentifier = StringConstants.cellIdentifier
    
    //MARK: - Private properties
    
    private let stackView: UIStackView =  {
        let view = UIStackView()
       
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .center
        view.spacing = LayoutConstants.stackViewSpacing
        
        return view
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        
        label.font = Fonts.timeLabel
        label.textColor = Resources.Colors.secondFontColor
        label.textAlignment = .center
        
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        
        label.font = Fonts.tempLabel
        label.textColor = Resources.Colors.secondFontColor
        label.textAlignment = .center
        
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageSize = CGSize(width: LayoutConstants.imageViewSize,
                               height: LayoutConstants.imageViewSize)
        let view = UIImageView(frame: .init(origin: .zero, size: imageSize))
    
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Extension with public methods

extension DayForecastCell {

    public func setup(data: OutputData) {
        self.timeLabel.text = data.time
        self.tempLabel.text = data.temperature
        self.imageView.image = UIImage(named: data.icon)
    }
    
}

//MARK: - Extension with private methods

private extension DayForecastCell {
    
    func configure() {
        backgroundColor = Resources.Colors.backgroundColor
        layer.cornerRadius = LayoutConstants.superViewCornerRadius
    
        stackView.frame = self.bounds
        
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(tempLabel)
        
        addSubview(stackView)
    }
    
}

//MARK: - Extension with private subobjects

private extension DayForecastCell {
    
    enum LayoutConstants {
        static let superViewCornerRadius: CGFloat = 15.0
        static let imageViewSize: CGFloat = 28.0
        static let stackViewSpacing: CGFloat = 5.0
    }
    
    enum Fonts {
        static let timeLabel: UIFont = .boldSystemFont(ofSize: 14)
        static let tempLabel: UIFont = .boldSystemFont(ofSize: 14)
    }
    
    enum StringConstants {
        static let cellIdentifier: String = "DayForecastCell"
    }
    
}
