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
    private weak var parentCoordinator: CoordinatorProtocol?
    private var childCoordinators: [CoordinatorProtocol]
    
    //MARK: - Initialaizers
    
    public init(parentCoordinator: CoordinatorProtocol? = nil, navigationController: UINavigationController, factory: WeatherListViewFactoryProtocol) {
        self.navigationController = navigationController
        self.factory = factory
        self.parentCoordinator = parentCoordinator
        self.childCoordinators = []
    }
    
}

extension WeatherListViewCoordinator: WeatherListViewCoordinatorProtocol {
    
    public func showWeatherView(coordinates: CDCoordinates, coordinator: WeatherListViewCoordinatorProtocol) {
        
        let factory = WeatherViewModuleFactory(
            coordinate: .init(lat: coordinates.latitude, lon: coordinates.longitude),
            networkManager: NetworkManager(),
            locationManager: LocationManager())
        
        
        let coordinator = WeatherViewCoordinator(coordinate: 
                .init(lat: coordinates.latitude,
                      lon: coordinates.longitude),
                                                 parentCoordinator: self,
                                                 navigationController: navigationController,
                                                 moduleFactory: factory)
        coordinator.start()
        
        childCoordinators.append(coordinator)
    }
    
    public func didFinish() {
        parentCoordinator?.childFinish(coordinator: self)
    }
}

extension WeatherListViewCoordinator: CoordinatorProtocol {
    
    public func start() {
        let view = factory.createWeatherListView(coordinator: self)
        
        navigationController.viewControllers = [view]
        
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


