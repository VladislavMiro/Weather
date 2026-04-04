//
//  WeatherListCell.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 08.12.2023.
//

import UIKit
import SnapKit

final class WeatherListCell: UICollectionViewListCell {

    //MARK: - Public properties
    
    public static let cellIdentifire = StringConstants.cellIdentifire
    
    //MARK: - Private properties
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = LayoutConstants.temperatureLabelNumbersOfLines
        label.font = Fonts.temperatureLabel
        label.textColor = Colors.temperatureLabelText
        label.textAlignment = .left
        
        return label
    }()
    
    private let regionLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = LayoutConstants.regionLabelNumbersOfLines
        label.font = Fonts.regionLabel
        label.textColor = Colors.regionLabelText
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        
        return label
    }()
    
    private let labelStack: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.spacing = LayoutConstants.labelStackSpacing
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
        view.layoutMargins = .init(top: LayoutConstants.stackViewVerticalMargins,
                                   left: LayoutConstants.stackViewHorizontalMargins,
                                   bottom: LayoutConstants.stackViewVerticalMargins,
                                   right: LayoutConstants.stackViewHorizontalMargins)
        view.spacing = LayoutConstants.stackViewSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        
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
    
}

//MARK: - Extension with public methods

extension WeatherListCell {
    
    public func update(data: WeatherListOutput) {
        temperatureLabel.text = data.temperature
        regionLabel.text = data.region
        imageView.image = UIImage(named: data.image)
    }
   
}

//MARK: - Extension with private methods

private extension WeatherListCell {
   
    func configuration() {
        self.backgroundConfiguration?.backgroundColor = Colors.background
        self.backgroundConfiguration?.cornerRadius = LayoutConstants.backgroundCornerRadius
        
        labelStack.addArrangedSubview(temperatureLabel)
        labelStack.addArrangedSubview(regionLabel)
        
        stackView.addArrangedSubview(labelStack)
        stackView.addArrangedSubview(imageView)
        
        contentView.addSubview(stackView)
    }
    
    func constraints() {
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(LayoutConstants.imageViewSize)
        }
        
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview { $0.layoutMarginsGuide }
            $0.leading.equalToSuperview { $0.layoutMarginsGuide }
                .offset(LayoutConstants.stackViewHorizontalMargins)
            $0.trailing.equalToSuperview { $0.layoutMarginsGuide }
                .inset(LayoutConstants.stackViewHorizontalMargins)
        }

    }
   
}

//MARK: - Extension with private subobjects

private extension WeatherListCell {
    
    enum LayoutConstants {
        static let imageViewSize: CGFloat = 80.0
        static let stackViewHorizontalOffset: CGFloat = 5.0
        static let temperatureLabelNumbersOfLines: Int = 1
        static let regionLabelNumbersOfLines: Int = 1
        static let labelStackSpacing: CGFloat = 5.0
        static let stackViewVerticalMargins: CGFloat = 0.0
        static let stackViewHorizontalMargins: CGFloat = 15.0
        static let stackViewSpacing: CGFloat = 15.0
        static let backgroundCornerRadius: CGFloat = 15.0
    }
    
    enum Fonts {
        static let temperatureLabel: UIFont = .boldSystemFont(ofSize: 36)
        static let regionLabel: UIFont = .boldSystemFont(ofSize: 16)
    }
    
    enum StringConstants {
        static let cellIdentifire: String = "WeatherLictCell"
    }
    
    enum Colors {
        static let background: UIColor? = R.color.secondBackgroundColor()
        static let temperatureLabelText: UIColor? = R.color.fontColor()
        static let regionLabelText: UIColor? = R.color.fontColor()
    }
    
}
