//
//  WeatherViewModuleFactory.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 07.12.2023.
//

import UIKit

final class WeatherViewModuleFactory {
    
    //MARK: - Private fields
    
    private let weatherViewFactory: WeatherViewFactoryProtocol
    private let detailViewFactory: DetailAirConditionViewFactoryProtocol
    private var coordinate: Coordinate?
    
    //MARK: - Initialaizers
    
    public init(networkManager: NetworkManagerProtocol, locationManager: LocationManagerProtocol) {
        self.weatherViewFactory = WeatherViewFactory(networkManager: networkManager, locationManager: locationManager)
        self.detailViewFactory = DetailAirConditionViewFactory()
    }
    
    convenience init(coordinate: Coordinate, networkManager: NetworkManagerProtocol, locationManager: LocationManagerProtocol) {
        self.init(networkManager: networkManager, locationManager: locationManager)
        self.coordinate = coordinate
    }
    
}

//MARK: WeatherViewModuleFactory implemntation

extension WeatherViewModuleFactory: WeatherViewModuleFatoryProtocol {
    
    public func createWeatherView(coordinator: WeatherViewCoordinatorProtocol) -> UIViewController {
        return weatherViewFactory.createWeatherView(coordinate: coordinate, coordinator: coordinator)
    }
    
    public func createDetailAirConditionView(data: WeatherResponseProtocol, coordinator: DetailAirConditionCoordinatorProtocol) -> UIViewController {
        return detailViewFactory.createDetailAirConditionView(data: data, coordinator: coordinator)
    }
    
    
}
