//
//  WeatherViewModuleFatoryProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 07.12.2023.
//

import UIKit

protocol WeatherViewModuleFatoryProtocol {
    
    typealias Coordinate = WeatherViewDataModels.Coordinates
    
    func createWeatherView(coordinator: WeatherViewCoordinatorProtocol) -> UIViewController
    func createDetailAirConditionView(data: WeatherResponseProtocol, coordinator: DetailAirConditionCoordinatorProtocol) -> UIViewController
    
}
