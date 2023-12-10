//
//  WeatherViewModuleFactoryProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 06.12.2023.
//

import UIKit

protocol WeatherViewModuleFactoryProtocol {
    
    typealias Coordinate = WeatherViewDataModels.Coordinates
    
    func createWeatherView(coordinator: WeatherViewCoordinatorProtocol) -> UIViewController
    func createDetailAirConditionView(data: WeatherResponseProtocol, coordinator: DetailAirConditionCoordinatorProtocol) -> UIViewController
    
}
