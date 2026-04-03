//
//  HeaderView.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 02.12.2023.
//

import UIKit
import Combine
import SnapKit

final class HeaderView: UIView {

    //MARK: - Private peoperties
    
    private let headerStack: UIStackView = {
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.spacing = LayoutConstants.headerStackSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private let labelsStack: UIStackView = {
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.spacing = LayoutConstants.labelStackSpacing
        stack.alignment = .center
        stack.distribution = .fill
        
        return stack
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Resources.Colors.fontColor
        label.textAlignment = .center
        label.font = Fonts.cityLabel
        
        return label
    }()
    
    private let descriptionLabel: UILabel =  {
        let label = UILabel()
        
        label.textColor = Resources.Colors.secondFontColor
        label.textAlignment = .center
        label.font = Fonts.descriptionLabel
        
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Resources.Colors.fontColor
        label.textAlignment = .center
        label.font = Fonts.temperatureLabel
        
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private var cancelable = Set<AnyCancellable>()
    
    //MARK: - Public properties
    
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
    
}

//MARK: - Extension with private methods

private extension HeaderView {
    
    func configuration() {
        labelsStack.addArrangedSubview(cityLabel)
        labelsStack.addArrangedSubview(descriptionLabel)

        headerStack.addArrangedSubview(labelsStack)
        headerStack.addArrangedSubview(imageView)
        headerStack.addArrangedSubview(temperatureLabel)
        
        self.addSubview(headerStack)
    }
    
    func bind() {
        viewModel.output.sink { [unowned self] data in
            self.cityLabel.text = data.regionName
            self.descriptionLabel.text = data.description
            self.temperatureLabel.text = data.temperature
            self.imageView.image = UIImage(named: data.icon)
        }.store(in: &cancelable)
    }
    
    func constraints() {
        
        imageView.snp.makeConstraints {
            $0.height.width.equalTo(LayoutConstants.iamgeSize)
        }
        
        headerStack.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
                .inset(LayoutConstants.offset)
        }
        
    }
    
}

//MARK: - Extension with private subpbjects

private extension HeaderView {
    
    enum LayoutConstants {
        static let offset: CGFloat = 25.0
        static let iamgeSize: CGFloat = 128.0
        static let headerStackSpacing: CGFloat = 25.0
        static let labelStackSpacing: CGFloat = 5.0
    }
    
    enum Fonts {
        static let cityLabel: UIFont = .systemFont(ofSize: 34, weight: .bold)
        static let descriptionLabel: UIFont = .systemFont(ofSize: 14, weight: .medium)
        static let temperatureLabel: UIFont = .boldSystemFont(ofSize: 64)
    }
    
}
