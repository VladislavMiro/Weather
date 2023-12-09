//
//  WeatherListViewCoordinatorProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 07.12.2023.
//

import UIKit

protocol WeatherListViewCoordinatorProtocol: AnyObject {
    
    func showWeatherView(coordinates: CDCoordinates, coordinator: WeatherListViewCoordinatorProtocol)
    func didFinish()
}
