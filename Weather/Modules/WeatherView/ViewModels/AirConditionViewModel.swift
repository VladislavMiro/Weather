//
//  AirConditionViewModel.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 05.12.2023.
//

import Foundation
import Combine

final class AirConditionViewModel: AirConditionViewModelProtocol {
    
    //MARK: - Public fields
    
    private(set) var output: CurrentValueSubject<Output,Never>
    private(set) var data: PassthroughSubject<WeatherResponseProtocol, Never>
    
    //MARK: - Private fields

    private let coordinator: WeatherViewCoordinatorProtocol
    
    private var passData: WeatherResponseProtocol?
    private var cancelable = Set<AnyCancellable>()
    
    //MARK: - Initializers
    
    public init(coordinator: WeatherViewCoordinatorProtocol) {
        self.coordinator = coordinator
        self.data = .init()
        
        self.output = .init(
            .init(wind: "0" + Symbols.kmPerHour.localized,
                  chanceOfRain: "0" + Symbols.precent.localized,
                  realFeel: "0" + Symbols.celciusSymbol.localized,
                  uvIndex: "0"
                 ))
        
        bind()
    }
    
    //MARK: - Public methods
    
    public func openWeatherDetailView() {
        guard let data = passData else { return }
        coordinator.openDetailAirConditionView(data: data)
    }
    
    //MARK: - Private methods
    
    private func bind() {
        data.sink { [weak self] data in
            self?.passData = data
            let convertedData = self?.converData(data: data) ?? .init(wind: "0" + Symbols.kmPerHour.localized,
                                                                     chanceOfRain: "0" + Symbols.precent.localized,
                                                                     realFeel: "0" + Symbols.celciusSymbol.localized,
                                                                     uvIndex: "0"
                                                                    )
            self?.output.send(convertedData)
        }.store(in: &cancelable)
    }
    
    private func converData(data: WeatherResponseProtocol) -> Output {
        let day: Int = data.forecast.first == nil ? 0 : data.forecast.first!.day.chanceOfRain
        let chanceOfRain = String(day) + Symbols.precent.localized
        
        return .init(wind: String(Int(data.current.wind)) + Symbols.kmPerHour.localized,
                     chanceOfRain: chanceOfRain,
                     realFeel:  String(Int(data.current.feelslikeC)) + Symbols.celciusSymbol.localized, uvIndex: String(Int(data.current.uv)))
    }
    
}
