//
//  AirConditionView.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 03.12.2023.
//

import UIKit
import Combine

final class AirConditionView: UIView {
    
    //MARK: - Private fields

    private let headerStack: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let gridStack: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.spacing = 10
        view.distribution = .fillEqually
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        
        label.textColor = Resources.Colors.secondFontColor
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "Air conditions"
        
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        
        button.setTitle("See more", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let realFeelItem: AirConditionsItem = AirConditionsItem()
    private let windItem: AirConditionsItem = AirConditionsItem()
    private let rainChanceItem: AirConditionsItem = AirConditionsItem()
    private let uvIndexItem: AirConditionsItem = AirConditionsItem()
    
    private var cancelable = Set<AnyCancellable>()
    
    //MARK: - Public fields
    
    public let viewModel: AirConditionViewModelProtocol
    
    //MARK: - Initializers
    
    public init(viewModel: AirConditionViewModelProtocol) {
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
        backgroundColor = Resources.Colors.secondBackgroundColor
        layer.cornerRadius = 15
        
        
        self.realFeelItem.itemLabel = "Feels like"
        self.realFeelItem.image = UIImage(named: "thermometer.medium")
        
        self.windItem.itemLabel = "Wind"
        self.windItem.image = UIImage(named: "wind")
        
        self.rainChanceItem.itemLabel = "Chance of rain"
        self.rainChanceItem.image = UIImage(named: "drop.fill")
        
        self.uvIndexItem.itemLabel = "UV Index"
        self.uvIndexItem.image = UIImage(named: "sun.max.fill")
        
        
        createHeader()
        createGridView()
    }
    
    private func bind() {
        viewModel.output.sink { [unowned self] data in
            realFeelItem.data = data.realFeel
            uvIndexItem.data = data.uvIndex
            windItem.data = data.wind
            rainChanceItem.data = data.chanceOfRain
        }.store(in: &cancelable)
    }
    
    private func createHeader() {
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        headerStack.addArrangedSubview(label)
        headerStack.addArrangedSubview(button)
        
        addSubview(headerStack)
    }
    
    private func createGridView() {
        let fLine = createGridLine()
        let sLine = createGridLine()

        fLine.addArrangedSubview(realFeelItem)
        fLine.addArrangedSubview(windItem)
        sLine.addArrangedSubview(rainChanceItem)
        sLine.addArrangedSubview(uvIndexItem)
        
        gridStack.addArrangedSubview(fLine)
        gridStack.addArrangedSubview(sLine)
        
        addSubview(gridStack)
    }
    
    private func createGridLine() -> UIStackView {
        let hItemStack = UIStackView()
        
        hItemStack.axis = .horizontal
        hItemStack.distribution = .fillEqually
        hItemStack.spacing = 10
        hItemStack.alignment = .fill
        
        return hItemStack
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 5),
            headerStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 15),
            headerStack.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: -15),
            
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            gridStack.topAnchor.constraint(equalTo: self.headerStack.bottomAnchor, constant: 10),
            gridStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 5),
            gridStack.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            gridStack.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            
            self.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    @objc private func buttonPressed() {
        viewModel.openWeatherDetailView()
    }
    
}
