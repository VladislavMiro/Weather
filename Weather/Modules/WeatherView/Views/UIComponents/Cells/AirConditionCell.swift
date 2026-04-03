//
//  AirConditionCell.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 06.12.2023.
//

import UIKit
import SnapKit

final class AirConditionCell: UICollectionViewListCell {
    
    //MARK: - Public properties
    
    typealias Data = DetailAirConditionDataModel.AirConditionCellOutputData
    
    public static let cellReuseIdentifier = StringConstants.cellReuseIdentifier
    
    //MARK: - Private properties
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.alignment = .leading
        view.spacing = LayoutConstants.stackViewSpacing
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private let labelStackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = LayoutConstants.labelStackViewSpacing
        view.distribution = .fill
        
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = LayoutConstants.labelNumberOfLines
        label.textColor = Resources.Colors.secondFontColor
        label.textAlignment = .left
        label.font = Fonts.label
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let dataLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = LayoutConstants.dataLabelNumberOfLines
        label.font = Fonts.dataLabel
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
    
}

//MARK: - Extension with public methods

extension AirConditionCell {
   
    public func setup(data: Data) {
        self.imageView.image = UIImage(systemName: data.icon)
        self.label.text = data.label
        self.dataLabel.text = data.data
    }
    
}

//MARK: - Extension with private methods

private extension AirConditionCell {
    
    func configuration() {
        backgroundConfiguration?.backgroundColor = Resources.Colors.secondBackgroundColor
        backgroundConfiguration?.cornerRadius = LayoutConstants.superViewCornerRadius
        
        labelStackView.addArrangedSubview(imageView)
        labelStackView.addArrangedSubview(label)

        stackView.addArrangedSubview(labelStackView)
        stackView.addArrangedSubview(dataLabel)
        
        contentView.addSubview(stackView)
    }
    
    func constraints() {
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview { $0.layoutMarginsGuide.snp.top }
                .offset(LayoutConstants.stackViewTopOffset)
            $0.leading.equalToSuperview { $0.layoutMarginsGuide.snp.leading }
                .offset(LayoutConstants.stackViewLeadingOffset)
            $0.trailing.bottom.equalToSuperview { $0.layoutMarginsGuide }
        }
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(LayoutConstants.imageViewSize)
        }
        
    }
    
}

//MARK: - Extension with private subobjects

private extension AirConditionCell {
    
    enum LayoutConstants {
        static let stackViewSpacing: CGFloat = 5.0
        static let labelStackViewSpacing: CGFloat = 5.0
        static let labelNumberOfLines: Int = 1
        static let dataLabelNumberOfLines: Int = 1
        static let superViewCornerRadius: CGFloat = 15.0
        static let stackViewTopOffset: CGFloat = 5.0
        static let stackViewLeadingOffset: CGFloat = 5.0
        static let imageViewSize: CGFloat = 14.0
    }
    
    enum Fonts {
        static let label: UIFont = .boldSystemFont(ofSize: 14)
        static let dataLabel: UIFont = .systemFont(ofSize: 36)
    }
    
    enum StringConstants {
        static let cellReuseIdentifier: String = String(describing: AirConditionCell.self)
    }
    
    enum Section: Int, CaseIterable {
        case main
    }
    
}


