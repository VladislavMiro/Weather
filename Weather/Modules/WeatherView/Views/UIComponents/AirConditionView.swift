//
//  AirConditionView.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 03.12.2023.
//

import UIKit
import Combine
import SnapKit

final class AirConditionView: UIView {
    
    //MARK: - Private properties

    private let headerStack: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillProportionally
        view.spacing = LayoutConstants.headerStackSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let gridStack: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.spacing = LayoutConstants.gridStackSpacing
        view.distribution = .fillEqually
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        
        label.textColor = Resources.Colors.secondFontColor
        label.textAlignment = .left
        label.font = Fonts.label
        label.text = StringConstants.label
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton(type: .custom, primaryAction: nil)
        
        button.setTitle(StringConstants.buttonLabel, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = LayoutConstants.buttonCornerRadius
        button.backgroundColor = .systemBlue
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        return button
    }()
    
    private let realFeelItem: AirConditionsItem = AirConditionsItem()
    private let windItem: AirConditionsItem = AirConditionsItem()
    private let rainChanceItem: AirConditionsItem = AirConditionsItem()
    private let uvIndexItem: AirConditionsItem = AirConditionsItem()
    
    private var cancelable = Set<AnyCancellable>()
    
    //MARK: - Public properties
    
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
    
}

//MARK: - Extension with private methods

private extension AirConditionView {
    
    func configuration() {
        backgroundColor = Resources.Colors.secondBackgroundColor
        layer.cornerRadius = LayoutConstants.superViewCornerRadius
        
        
        self.realFeelItem.itemLabel = StringConstants.realFeelItemLabel
        self.realFeelItem.image = Images.realFeelItem
        
        self.windItem.itemLabel = StringConstants.windItemLabel
        self.windItem.image = Images.windItem
        
        self.rainChanceItem.itemLabel = StringConstants.rainChanceItemLabel
        self.rainChanceItem.image = Images.rainChanceItem
        
        self.uvIndexItem.itemLabel = StringConstants.uvIndexItemLabel
        self.uvIndexItem.image = Images.uvIndexItem
        
        
        createHeader()
        createGridView()
    }
    
    func bind() {
        viewModel.output.sink { [weak self] data in
            self?.realFeelItem.data = data.realFeel
            self?.uvIndexItem.data = data.uvIndex
            self?.windItem.data = data.wind
            self?.rainChanceItem.data = data.chanceOfRain
        }.store(in: &cancelable)
    }
    
    func createHeader() {
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        headerStack.addArrangedSubview(label)
        headerStack.addArrangedSubview(button)
        
        addSubview(headerStack)
    }
    
    func createGridView() {
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
    
    func createGridLine() -> UIStackView {
        let hItemStack = UIStackView()
        
        hItemStack.axis = .horizontal
        hItemStack.distribution = .fillEqually
        hItemStack.spacing = LayoutConstants.gridItemStackSpacing
        hItemStack.alignment = .fill
        
        return hItemStack
    }
    
    func constraints() {
        
        self.snp.makeConstraints {
            $0.height.equalTo(LayoutConstants.superViewHeight)
        }
        
        headerStack.snp.makeConstraints {
            $0.top.equalToSuperview()
                .offset(LayoutConstants.headerStackTopOffset)
            $0.leading.equalToSuperview()
                .offset(LayoutConstants.headerStackHorizontalOffset)
            $0.trailing.equalToSuperview()
                .inset(LayoutConstants.headerStackHorizontalOffset)
        }
        
        gridStack.snp.makeConstraints {
            $0.top.equalTo(headerStack.snp.bottom)
                .offset(LayoutConstants.gridStackTopOffset)
            $0.leading.equalToSuperview()
                .offset(LayoutConstants.gridStackLeadingOffset)
            $0.trailing.bottom.equalToSuperview()
                .inset(LayoutConstants.gridStackBottomOffset)
        }
    
    }
    
    @objc func buttonPressed() {
        viewModel.openWeatherDetailView()
    }
    
}

//MARK: - Extension with private subobjects

private extension AirConditionView {
    
    enum LayoutConstants {
        static let headerStackSpacing: CGFloat = 20.0
        static let headerStackTopOffset: CGFloat = 5.0
        static let headerStackHorizontalOffset: CGFloat = 15.0
        static let gridStackTopOffset: CGFloat = 10.0
        static let gridStackLeadingOffset: CGFloat = 5.0
        static let superViewCornerRadius: CGFloat = 15.0
        static let superViewHeight: CGFloat = 220.0
        static let gridStackSpacing: CGFloat = 10.0
        static let gridItemStackSpacing: CGFloat = 10.0
        static let gridStackBottomOffset: CGFloat = 10.0
        static let buttonCornerRadius: CGFloat = 10.0
    }
    
    enum Fonts {
        static let label: UIFont = .boldSystemFont(ofSize: 16)
    }
    
    enum StringConstants {
        static let label: String = "Air conditions"
        static let buttonLabel: String = "See more"
        static let realFeelItemLabel: String = "Feels like"
        static let windItemLabel: String = "Wind"
        static let rainChanceItemLabel: String = "Chance of rain"
        static let uvIndexItemLabel: String = "UV Index"
    }
    
    enum Images {
        static let realFeelItem: UIImage? = UIImage(named: "thermometer.medium")
        static let windItem: UIImage? = UIImage(named: "wind")
        static let rainChanceItem: UIImage? = UIImage(named: "drop.fill")
        static let uvIndexItem: UIImage? = UIImage(named: "sun.max.fill")
    }
    
}
