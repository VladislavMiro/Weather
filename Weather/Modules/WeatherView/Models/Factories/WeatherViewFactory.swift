//
//  WeatherViewFactory.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 06.12.2023.
//

import UIKit

final class WeatherViewFactory {
    
    //MARK: - Private fields
    
    private let networkManager: NetworkManagerProtocol
    private let locationManager: LocationManagerProtocol

    //MARK: - Initializers
    
    public init(networkManager: NetworkManagerProtocol, locationManager: LocationManagerProtocol) {
        self.networkManager = networkManager
        self.locationManager = locationManager
    }
    
    //MARK: - Private methods
    
    private func createView(coordinate: Coordinate? = nil, coordinator: WeatherViewCoordinatorProtocol) -> UIViewController {
        
        let headerViewmodel = HeaderViewModel()
        let dayForecastViewModel = DayForecastViewModel()
        let weekForecastViewModel = WeekForecastViewModel()
        let airConditionViewModel = AirConditionViewModel(coordinator: coordinator)
        var weatherViewModel: WeatherViewModelProtocol
        
        let headerView = HeaderView(viewModel: headerViewmodel)
        let dayForecastView = DayForecastView(viewModel: dayForecastViewModel)
        let weekForecastView = WeekForecastView(viewModel: weekForecastViewModel)
        let airConditionView = AirConditionView(viewModel: airConditionViewModel)
        
        
        if let coordinate = coordinate {
            weatherViewModel = WeatherViewModel(coordinator: coordinator, networkManager: networkManager, coordinate: coordinate)
            
        } else {
            weatherViewModel = WeatherViewModel(coordinator: coordinator, networkManager: networkManager, locationManager: locationManager)
        }
        
        let view = WeatherViewController(headerView: headerView,
                                         dayForecastView: dayForecastView,
                                         weekForecast: weekForecastView,
                                         airConditionView: airConditionView,
                                         viewModel: weatherViewModel)
        return view
    }
    
}

extension WeatherViewFactory: WeatherViewFactoryProtocol {
    
    public func createWeatherView(coordinate: Coordinate? = nil, coordinator: WeatherViewCoordinatorProtocol) -> UIViewController {
        return createView(coordinate: coordinate, coordinator: coordinator)
    }

}
