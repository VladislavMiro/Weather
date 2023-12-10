//
//  WeatherViewFactoryProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 06.12.2023.
//

import UIKit

protocol WeatherViewFactoryProtocol: AnyObject {
    
    typealias Coordinate = WeatherViewDataModels.Coordinates
    
    func createWeatherView(coordinate: Coordinate?, coordinator: WeatherViewCoordinatorProtocol) -> UIViewController
    
}
