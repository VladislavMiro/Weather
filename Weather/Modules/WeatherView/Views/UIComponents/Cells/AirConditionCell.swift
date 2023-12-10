//
//  AirConditionCell.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 06.12.2023.
//

import UIKit

final class AirConditionCell: UICollectionViewListCell {
    
    //MARK: - Public fields
    
    typealias Data = DetailAirConditionDataModel.AirConditionCellOutputData
    
    public static let cellReuseIdentifier = "AirConditionCell"
    
    //MARK: - Private fields
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.alignment = .leading
        view.spacing = 5
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private let labelStackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 5
        view.distribution = .fill
        
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        label.textColor = Resources.Colors.secondFontColor
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let dataLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 36)
        label.textColor = Resources.Colors.fontColor
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.tintColor = Resources.Colors.secondFontColor
        
        return view
    }()
    
    //MARK: - Initialaizers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    
    public func setup(data: Data) {
        self.imageView.image = UIImage(systemName: data.icon)
        self.label.text = data.label
        self.dataLabel.text = data.data
    }
    
    //MARK: - Private methods
    
    private func configuration() {
        backgroundConfiguration?.backgroundColor = Resources.Colors.secondBackgroundColor
        backgroundConfiguration?.cornerRadius = 15
        
        labelStackView.addArrangedSubview(imageView)
        labelStackView.addArrangedSubview(label)

        stackView.addArrangedSubview(labelStackView)
        stackView.addArrangedSubview(dataLabel)
        
        contentView.addSubview(stackView)
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            
            imageView.heightAnchor.constraint(equalToConstant: 14),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
    
}
