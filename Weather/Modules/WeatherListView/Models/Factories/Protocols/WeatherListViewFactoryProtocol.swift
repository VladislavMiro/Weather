//
//  WeatherListViewFactoryProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 07.12.2023.
//

import UIKit

protocol WeatherListViewFactoryProtocol: AnyObject {
    
    func createWeatherListView(coordinator: WeatherListViewCoordinatorProtocol) -> UIViewController
    
}
