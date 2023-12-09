//
//  DayForecastCell.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 02.12.2023.
//

import UIKit
import Combine

final class DayForecastCell: UICollectionViewCell {
    
    //MARK: - Public fields
    
    typealias OutputData = WeatherViewDataModels.DayForecastCellOutputData
    
    public static let cellIdentifier = "DayForecastCell"
    
    //MARK: - Private fields
    
    private let stackView: UIStackView =  {
        let view = UIStackView()
       
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .center
        view.spacing = 5
        
        return view
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = Resources.Colors.secondFontColor
        label.textAlignment = .center
        
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = Resources.Colors.secondFontColor
        label.textAlignment = .center
        
        return label
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView(frame: .init(origin: .zero, size: .init(width: 28, height: 28)))
    
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
    
    //MARK: - Public Methods
    
    public func setup(data: OutputData) {
        self.timeLabel.text = data.time
        self.tempLabel.text = data.temperature
        self.imageView.image = UIImage(named: data.icon)
    }
    
    //MARK: - Private methods
    
    private func configure() {
        backgroundColor = Resources.Colors.backgroundColor
        layer.cornerRadius = 15
    
        stackView.frame = self.bounds
        
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(tempLabel)
        
        addSubview(stackView)
    }
    
}
