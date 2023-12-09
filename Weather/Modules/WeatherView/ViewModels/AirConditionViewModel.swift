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
            .init(wind: "0" + Resources.Symbols.kmPerHour,
                  chanceOfRain: "0" + Resources.Symbols.precent,
                  realFeel: "0" + Resources.Symbols.celciusSymbol,
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
        data.sink { [unowned self] data in
            self.passData = data
            self.output.send(self.converData(data: data))
        }.store(in: &cancelable)
    }
    
    private func converData(data: WeatherResponseProtocol) -> Output {
        let day: Int = data.forecast.first == nil ? 0 : data.forecast.first!.day.chanceOfRain
        let chanceOfRain = String(day) + Resources.Symbols.precent
        
        return .init(wind: String(Int(data.current.wind)) + Resources.Symbols.kmPerHour,
                     chanceOfRain: chanceOfRain, 
                     realFeel:  String(Int(data.current.feelslikeC)) + Resources.Symbols.celciusSymbol, uvIndex: String(Int(data.current.uv)))
    }
    
}
