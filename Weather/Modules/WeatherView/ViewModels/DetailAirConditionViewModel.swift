//
//  DetailAirConditionViewModel.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 05.12.2023.
//

import Foundation
import Combine

final class DetailAirConditionViewModel: DetailAirConditionViewModelProtocol {
    
    typealias Output = DetailAirConditionDataModel.AirConditionCellOutputData
    
    //MARK: - Public fields
    
    private(set) var output: CurrentValueSubject<[Output], Never> = .init([])
    private(set) var data: CurrentValueSubject<WeatherResponseProtocol, Never>
    
    //MARK: - Private fields
    
    private let coordinator: DetailAirConditionCoordinatorProtocol
    
    private var cancelable = Set<AnyCancellable>()
    
    //MARK: - Initializers
 
    public init(data: WeatherResponseProtocol, coordinator: DetailAirConditionCoordinatorProtocol) {
        self.data = .init(data)
        self.coordinator = coordinator
        
        bind()
    }
    
    //MARK: - Public fields
    
    public func finish() {
        coordinator.didFinish()
    }
    
    //MARK: - Private methods
    
    private func bind() {
        data
            .map { [unowned self] data -> [DetailAirConditionViewModel.Output] in
                return self.converData(data: data)
            }
            .sink { [unowned self] data in
                self.output.send(data)
            }.store(in: &cancelable)
    }
    
    private func converData(data: WeatherResponseProtocol) -> [Output] {
        
        guard let currWeather = data.forecast.first?.day else { return [] }
        
        let maxTemp = String(Int(currWeather.maxTemp)) + Resources.Symbols.celciusSymbol
        let minTemp = String(Int(currWeather.minTemp)) + Resources.Symbols.celciusSymbol
        let chanceOfRain = String(currWeather.chanceOfRain) + Resources.Symbols.precent
        let chanceOfShow = String(currWeather.chanceOfShow) + Resources.Symbols.precent
        let uv = String(Int(data.current.uv))
        let wind = String(Int(data.current.wind)) + Resources.Symbols.kmPerHour
        let visibility = String(Int(data.current.visKm)) + Resources.Symbols.km
        let hummidity = String(Int(data.current.humidity)) + Resources.Symbols.precent
        let feelsLike = String(Int(data.current.feelslikeC)) + Resources.Symbols.celciusSymbol
        let precip = String(Int(data.current.precip)) + Resources.Symbols.mm
        let pressure = String(Int(data.current.pressure)) + Resources.Symbols.hPa
        let gust = String(Int(data.current.gust)) + Resources.Symbols.kmPerHour
        
        var array: [Output] = []
        
        array.append(.init(label: "Feels like", icon: "thermometer.medium", data: feelsLike))
        array.append(.init(label: "Wind", icon: "wind", data: wind))
        array.append(.init(label: "Min temperature", icon: "thermometer.low", data: minTemp))
        array.append(.init(label: "Max temperature", icon: "thermometer.high", data: maxTemp))
        array.append(.init(label: "Chance of rain", icon: "cloud.rain", data: chanceOfRain))
        array.append(.init(label: "Chance of snow", icon: "cloud.snow", data: chanceOfShow))
        array.append(.init(label: "Hummidity", icon: "humidity", data: hummidity))
        array.append(.init(label: "Visibility", icon: "eye", data: visibility))
        array.append(.init(label: "Precipitation", icon: "cloud.drizzle.fill", data: precip))
        array.append(.init(label: "Pressure", icon: "cloud.circle", data: pressure))
        array.append(.init(label: "Gust", icon: "aqi.medium", data: gust))
        array.append(.init(label: "UV Index", icon: "sun.max.fill", data: uv))
        
        return array
    }
}
