//
//  WeekDayCell.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 02.12.2023.
//

import UIKit

final class WeekDayCell: UITableViewCell {

    //MARK: - Public fields
    
    public static let cellIdentifier = "WeekDayCell"
    
    //MARK: - Private fields
    
    private let imageStack: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 5
        
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
    
        label.font = .systemFont(ofSize: 14)
        label.textColor = Resources.Colors.secondFontColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = Resources.Colors.secondFontColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        label.textColor = Resources.Colors.secondFontColor
        
        return label
    }()
    
    private let image: UIImageView = {
        let view = UIImageView()
        
        view.contentMode = .center
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    //MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configuration()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    
    public func setData(data: WeatherViewDataModels.WeekForecastOutputData) {
        self.dayLabel.text = data.day
        self.conditionLabel.text = data.condition
        self.temperatureLabel.text = data.temperature
        self.image.image = UIImage(named: data.icon) 
    }
    
    //MARK: - Private methods
    
    private func configuration() {
        backgroundColor = Resources.Colors.secondBackgroundColor
        
        imageStack.addArrangedSubview(image)
        imageStack.addArrangedSubview(conditionLabel)
        
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(imageStack)
        stackView.addArrangedSubview(temperatureLabel)
        
        contentView.addSubview(stackView)
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            dayLabel.widthAnchor.constraint(equalToConstant: 80),
            temperatureLabel.widthAnchor.constraint(equalToConstant: 50),
                        
            image.heightAnchor.constraint(equalToConstant: 32),
            image.widthAnchor.constraint(equalTo: image.heightAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
}
