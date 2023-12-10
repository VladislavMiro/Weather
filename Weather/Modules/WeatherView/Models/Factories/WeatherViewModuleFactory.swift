//
//  WeatherViewModuleFactory.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 07.12.2023.
//

import UIKit

final class WeatherViewModuleFactory {
    
    //MARK: - Private fields
    
    private let locationManager: LocationManager
    private let networkManager: NetworkManagerProtocol

    private var coordinate: Coordinate?
    
    //MARK: - Initialaizers
    
    public init(coordinate: Coordinate?) {
        self.networkManager = NetworkManager()
        self.locationManager = LocationManager()
        self.coordinate = coordinate
    }
    
}

//MARK: WeatherViewModuleFactory implemntation

extension WeatherViewModuleFactory: WeatherViewModuleFactoryProtocol {
    
    public func createWeatherView(coordinator: WeatherViewCoordinatorProtocol) -> UIViewController {
        
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
            weatherViewModel = WeatherViewModel(
                coordinator: coordinator,
                networkManager: networkManager,
                coordinate: coordinate)
            
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
    
    public func createDetailAirConditionView(data: WeatherResponseProtocol, coordinator: DetailAirConditionCoordinatorProtocol) -> UIViewController {
        
        let headerViewModel = HeaderViewModel()
        let viewModel = DetailAirConditionViewModel(data: data, coordinator: coordinator)
        let header = HeaderView(viewModel: headerViewModel)
        let view = DetailAirConditionView(viewModel: viewModel, header: header)
        
        return view
    }
    
    
}
