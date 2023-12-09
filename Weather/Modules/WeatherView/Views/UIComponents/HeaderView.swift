//
//  HeaderView.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 02.12.2023.
//

import UIKit
import Combine

final class HeaderView: UIView {

    //MARK: - Private fields
    
    private let headerStack: UIStackView = {
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.spacing = 25
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private let labelsStack: UIStackView = {
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .center
        stack.distribution = .fill
        
        return stack
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Resources.Colors.fontColor
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 34, weight: .bold)
        
        return label
    }()
    
    private let descriptionLabel: UILabel =  {
        let label = UILabel()
        
        label.textColor = Resources.Colors.secondFontColor
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Resources.Colors.fontColor
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 64)
        
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private var cancelable = Set<AnyCancellable>()
    
    //MARK: - Public fields
    
    public let viewModel: HeaderViewModelProtocol
    
    //MARK: - Initializers
    
    public init(viewModel: HeaderViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        configuration()
        constraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    
    private func configuration() {
        labelsStack.addArrangedSubview(cityLabel)
        labelsStack.addArrangedSubview(descriptionLabel)

        headerStack.addArrangedSubview(labelsStack)
        headerStack.addArrangedSubview(imageView)
        headerStack.addArrangedSubview(temperatureLabel)
        
        self.addSubview(headerStack)
    }
    
    private func bind() {
        viewModel.output.sink { [unowned self] data in
            self.cityLabel.text = data.regionName
            self.descriptionLabel.text = data.description
            self.temperatureLabel.text = data.temperature
            self.imageView.image = UIImage(named: data.icon)
        }.store(in: &cancelable)
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 128),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            headerStack.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            headerStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            headerStack.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: self.layoutMargins.bottom - 25),
        ])
    }
}
