//
//  WeatherListViewCoordinator.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 07.12.2023.
//

import UIKit

final class WeatherListViewCoordinator {
    
    //MARK: - Private fields
    
    private let navigationController: UINavigationController
    
    private let factory: WeatherListViewFactoryProtocol
    
    private var childCoordinators: [CoordinatorProtocol]
    
    //MARK: - Initialaizers
    
    public init(navigationController: UINavigationController, factory: WeatherListViewFactoryProtocol) {
        self.navigationController = navigationController
        self.factory = factory
        self.childCoordinators = []
    }
    
}

extension WeatherListViewCoordinator: WeatherListViewCoordinatorProtocol {
    
    public func showWeatherView(coordinates: CDCoordinates, coordinator: WeatherListViewCoordinatorProtocol) {
        let factory = WeatherViewModuleFactory(
            coordinate: .init(lat: coordinates.latitude, lon: coordinates.longitude),
            networkManager: NetworkManager(),
            locationManager: LocationManager())
        
        
        let coordinator = WeatherViewCoordinator(parentCoordinator: self,
                                                 navigationController: navigationController, 
                                                 moduleFactory: factory)
        coordinator.start()
        
    }
}

extension WeatherListViewCoordinator: CoordinatorProtocol {
    
    public func start() {
        let view = factory.createWeatherListView(coordinator: self)
        
        navigationController.pushViewController(view, animated: false)
        
    }
    
    public func childFinish(coordinator: CoordinatorProtocol) {
        
        childCoordinators.enumerated().forEach { child in
            if child.element === coordinator {
                childCoordinators.remove(at: child.offset)
                return
            }
        }
        
    }
    
}


