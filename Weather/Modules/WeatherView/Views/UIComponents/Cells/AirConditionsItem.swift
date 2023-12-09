//
//  AirConditionsItem.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 03.12.2023.
//

import UIKit

final class AirConditionsItem: UIView {
    
    //MARK: - Public fields
    
    public var itemLabel: String = "" {
        didSet {
            label.text = itemLabel
        }
    }
    
    public var data: String = "" {
        didSet {
            dataLabel.text = data
        }
    }
    
    public var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    //MARK: - Private fields
    
    private let imageStack: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.spacing = 10
        view.alignment = .leading
        view.distribution = .fillEqually
        
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.alignment = .trailing
        view.distribution = .fillProportionally
        view.spacing = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView(frame: .init(origin: .zero, size: .init(width: 16, height: 16)))
        
        view.tintColor = Resources.Colors.secondFontColor
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private let label: UILabel =  {
        let label = UILabel()

        label.font = .systemFont(ofSize: 16)
        label.textColor = Resources.Colors.secondFontColor
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let dataLabel: UILabel = {
        let label = UILabel()
    
        label.font = .systemFont(ofSize: 16)
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
    
    //MARK: - Private methods
    
    private func configuration() {
        imageStack.addArrangedSubview(label)
        imageStack.addArrangedSubview(dataLabel)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(imageStack)
        
        stackView.frame = self.bounds
        
        addSubview(stackView)
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
}
