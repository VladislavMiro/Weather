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
        
        let maxTemp = String(Int(currWeather.maxTemp)) + Symbols.celciusSymbol.localized
        let minTemp = String(Int(currWeather.minTemp)) + Symbols.celciusSymbol.localized
        let chanceOfRain = String(currWeather.chanceOfRain) + Symbols.precent.localized
        let chanceOfShow = String(currWeather.chanceOfShow) + Symbols.precent.localized
        let uv = String(Int(data.current.uv))
        let wind = String(Int(data.current.wind)) + Symbols.kmPerHour.localized
        let visibility = String(Int(data.current.visKm)) + Symbols.km.localized
        let hummidity = String(Int(data.current.humidity)) + Symbols.precent.localized
        let feelsLike = String(Int(data.current.feelslikeC)) + Symbols.celciusSymbol.localized
        let precip = String(Int(data.current.precip)) + Symbols.mm.localized
        let pressure = String(Int(data.current.pressure)) + Symbols.hPa.localized
        let gust = String(Int(data.current.gust)) + Symbols.kmPerHour.localized
        
        var array: [Output] = []
        
        array.append(.init(label: AirConditionsItems.FeelsLike.localizedLabel,
                           icon: AirConditionsItems.FeelsLike.imageName,
                           data: feelsLike))
        array.append(.init(label: AirConditionsItems.Wind.localizedLabel,
                           icon: AirConditionsItems.Wind.imageName,
                           data: wind))
        array.append(.init(label: AirConditionsItems.MinTemperature.localizedLabel,
                           icon: AirConditionsItems.MinTemperature.imageName,
                           data: minTemp))
        array.append(.init(label: AirConditionsItems.MaxTemperatures.localizedLabel,
                           icon: AirConditionsItems.MaxTemperatures.imageName,
                           data: maxTemp))
        array.append(.init(label: AirConditionsItems.ChanceOfRain.localizedLabel,
                           icon: AirConditionsItems.ChanceOfRain.imageName,
                           data: chanceOfRain))
        array.append(.init(label: AirConditionsItems.ChanceOfSnow.localizedLabel,
                           icon: AirConditionsItems.ChanceOfRain.imageName,
                           data: chanceOfShow))
        array.append(.init(label: AirConditionsItems.Hummidity.localizedLabel,
                           icon: AirConditionsItems.Hummidity.imageName,
                           data: hummidity))
        array.append(.init(label: AirConditionsItems.Visibility.localizedLabel,
                           icon: AirConditionsItems.Visibility.imageName,
                           data: visibility))
        array.append(.init(label: AirConditionsItems.Precipitation.localizedLabel,
                           icon: AirConditionsItems.Precipitation.imageName,
                           data: precip))
        array.append(.init(label: AirConditionsItems.Pressure.localizedLabel,
                           icon: AirConditionsItems.Pressure.imageName,
                           data: pressure))
        array.append(.init(label: AirConditionsItems.Gust.localizedLabel,
                           icon: AirConditionsItems.Gust.imageName,
                           data: gust))
        array.append(.init(label: AirConditionsItems.UVIndex.localizedLabel,
                           icon: AirConditionsItems.UVIndex.imageName,
                           data: uv))
        
        return array
    }
}
