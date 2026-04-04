//
//  WeekDayCell.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 02.12.2023.
//

import UIKit
import SnapKit

final class WeekDayCell: UITableViewCell {

    //MARK: - Public properties
    
    public static let cellIdentifier = StringConstants.cellIdentifier
    
    //MARK: - Private properties
    
    private let imageStack: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = LayoutConstants.imageStackSpacing
        
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = LayoutConstants.stackViewSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
    
        label.font = Fonts.dayLabel
        label.textColor = Colors.dayLabelText
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.font = Fonts.temperatureLabel
        label.numberOfLines = Constants.numberOfLines
        label.textAlignment = .right
        label.textColor = Colors.temperatureLabelText
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        
        label.font = Fonts.conditionLabel
        label.numberOfLines = Constants.numberOfLines
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.textColor = Colors.conditionLabelText
        
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
    
}

//MARK: - Extension with public methods

extension WeekDayCell {
    
    public func setData(data: WeatherViewDataModels.WeekForecastOutputData) {
        self.dayLabel.text = data.day
        self.conditionLabel.text = data.condition
        self.temperatureLabel.text = data.temperature
        self.image.image = UIImage(named: data.icon)
    }
    
}

//MARK: - Extension with private methods

private extension WeekDayCell {
    
    func configuration() {
        backgroundColor = Colors.background
        
        imageStack.addArrangedSubview(image)
        imageStack.addArrangedSubview(conditionLabel)
        
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(imageStack)
        stackView.addArrangedSubview(temperatureLabel)
        
        contentView.addSubview(stackView)
    }
    
    func constraints() {
        
        dayLabel.snp.makeConstraints {
            $0.width.equalTo(LayoutConstants.dayLabelWidth)
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.width.equalTo(LayoutConstants.temperatureLabelWidth)
        }
        
        image.snp.makeConstraints {
            $0.size.equalTo(LayoutConstants.imageViewSize)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalTo(contentView.layoutMarginsGuide.snp.edges)
        }
        
    }
    
}

//MARK: - Extension with private subobjects

private extension WeekDayCell {
    
    enum LayoutConstants {
        static let dayLabelWidth: CGFloat = 80.0
        static let temperatureLabelWidth: CGFloat = 50.0
        static let imageViewSize: CGFloat = 32.0
        static let imageStackSpacing: CGFloat = 5.0
        static let stackViewSpacing: CGFloat = 5.0
    }
    
    enum Constants {
        static let numberOfLines: Int = 1
    }
    
    enum Fonts {
        static let dayLabel: UIFont = .systemFont(ofSize: 14)
        static let temperatureLabel: UIFont = .systemFont(ofSize: 14)
        static let conditionLabel: UIFont = .systemFont(ofSize: 14)
    }
    
    enum StringConstants {
        static let cellIdentifier: String = String(describing: WeekDayCell.self)
    }
    
    enum Colors {
        static let background: UIColor? = R.color.secondBackgroundColor()
        static let dayLabelText: UIColor? = R.color.secondFontColor()
        static let temperatureLabelText: UIColor? = R.color.secondFontColor()
        static let conditionLabelText: UIColor? = R.color.secondFontColor()
    }
    
}
