//
//  AirConditionsItem.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 03.12.2023.
//

import UIKit
import SnapKit

final class AirConditionsItem: UIView {
    
    //MARK: - Public properties
    
    public var itemLabel: String = StringConstants.LabelDefaultValue {
        didSet {
            label.text = itemLabel
        }
    }
    
    public var data: String = StringConstants.LabelDefaultValue {
        didSet {
            dataLabel.text = data
        }
    }
    
    public var image: UIImage? = Images.imageDefaulValue {
        didSet {
            imageView.image = image
        }
    }
    
    //MARK: - Private properties
    
    private let imageStack: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.spacing = LayoutConstants.imageStackSpacing
        view.alignment = .leading
        view.distribution = .fillEqually
        
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.alignment = .trailing
        view.distribution = .fillProportionally
        view.spacing = LayoutConstants.stackViewSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageSize = CGSize(width: LayoutConstants.imageViewSize,
                               height: LayoutConstants.imageViewSize)
        let view = UIImageView(frame: .init(origin: .zero, size: imageSize))
        
        view.tintColor = Resources.Colors.secondFontColor
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private let label: UILabel =  {
        let label = UILabel()

        label.font = Fonts.label
        label.textColor = Resources.Colors.secondFontColor
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let dataLabel: UILabel = {
        let label = UILabel()
    
        label.font = Fonts.dataLabel
        label.textAlignment = .center
        label.textColor = Resources.Colors.fontColor
        
        return label
    }()
    
    //MARK: - Initializers
    
    public init(itemLabel: String, image: String, data: String) {
        self.label.text = itemLabel
        self.imageView.image = .init(systemName: image)
        self.dataLabel.text = data
        
        super.init(frame: .zero)
        
        configuration()
        constraints()
    }
    
    public init() {
        super.init(frame: .zero)
        
        configuration()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Extension with private methods

private extension AirConditionsItem {

    func configuration() {
        imageStack.addArrangedSubview(label)
        imageStack.addArrangedSubview(dataLabel)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(imageStack)
        
        stackView.frame = self.bounds
        
        addSubview(stackView)
    }
    
    func constraints() {
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview { $0.layoutMarginsGuide.snp.edges }
        }
        
        /*NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
        ])*/
    }
    
}

//MARK: - Extension with private subobjects

private extension AirConditionsItem {
    
    enum LayoutConstants {
        static let imageViewSize: CGFloat = 16.0
        static let imageStackSpacing: CGFloat = 10.0
        static let stackViewSpacing: CGFloat = 5.0
    }
    
    enum Fonts {
        static let label: UIFont = .systemFont(ofSize: 16)
        static let dataLabel: UIFont = .systemFont(ofSize: 16)
    }
    
    enum StringConstants {
        static let LabelDefaultValue: String = ""
    }
    
    enum Images {
        static let imageDefaulValue: UIImage? = nil
    }
    
}
