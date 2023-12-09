//
//  WeatherListCell.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 08.12.2023.
//

import UIKit

final class WeatherListCell: UICollectionViewListCell {

    //MARK: - Public fields
    
    public static let cellIdentifire = "WeatherLictCell"
    
    //MARK: - Private fields
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 36)
        label.textColor = Resources.Colors.fontColor
        label.textAlignment = .left
        
        return label
    }()
    
    private let regionLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = Resources.Colors.fontColor
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        
        return label
    }()
    
    private let labelStack: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.spacing = 5
        view.alignment = .leading
        view.distribution = .fillProportionally
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.alignment = .center
        view.distribution  = .fillProportionally
        view.layoutMargins = .init(top: 0, left: 15, bottom: 0, right: 15)
        view.spacing = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    
    public func update(data: WeatherListOutput) {
        temperatureLabel.text = data.temperature
        regionLabel.text = data.region
        imageView.image = UIImage(named: data.image)
    }
    
    //MARK: - Pribvate methods

    private func configuration() {
        self.backgroundConfiguration?.backgroundColor = Resources.Colors.secondBackgroundColor
        self.backgroundConfiguration?.cornerRadius = 15
        
        labelStack.addArrangedSubview(temperatureLabel)
        labelStack.addArrangedSubview(regionLabel)
        
        stackView.addArrangedSubview(labelStack)
        stackView.addArrangedSubview(imageView)
        
        contentView.addSubview(stackView)
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            stackView.topAnchor
                .constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor
                .constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor, constant: 5),
            stackView.trailingAnchor
                .constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor, constant: 5),
            stackView.bottomAnchor
                .constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
}
