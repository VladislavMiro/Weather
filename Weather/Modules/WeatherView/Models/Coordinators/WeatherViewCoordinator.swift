//
//  WeatherViewCoordinator.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 05.12.2023.
//

import UIKit
import Combine

final class WeatherViewCoordinator {
    
    //MARK: - Private fields

    private var childCoordinators: [CoordinatorProtocol]
    
    private let navigationController: UINavigationController
    private let moduleFactory: WeatherViewModuleFactory
    private weak var parentCoordinator: CoordinatorProtocol?
    
    //MARK: - Initialaizer
    
    public init(parentCoordinator: CoordinatorProtocol, navigationController: UINavigationController, moduleFactory: WeatherViewModuleFactory) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
        self.parentCoordinator = parentCoordinator
        
        self.childCoordinators = []
    }
    
}

extension WeatherViewCoordinator: WeatherViewCoordinatorProtocol {
    
    public func openDetailAirConditionView(data: WeatherResponseProtocol) {
        let coordinator = DetailAirConditionCoordinator(data: data, navigationController: self.navigationController, parentCoordinator: self, moduleFactory: self.moduleFactory)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    public func openWeatherView(with data: WeatherViewDataModels.Coordinates) {
        let view = moduleFactory.createWeatherView(coordinator: self)
        
        
        navigationController.pushViewController(view, animated: true)
    }
    
    public func finish() {
        parentCoordinator?.childFinish(coordinator: self)
    }
    
}

extension WeatherViewCoordinator: CoordinatorProtocol {
    
    public func start() {
        let view = moduleFactory.createWeatherView(coordinator: self)
        navigationController.viewControllers = [view]
    }
    
    public func childFinish(coordinator: CoordinatorProtocol) {
        childCoordinators.enumerated().forEach { child in
            if child.element === coordinator {
                childCoordinators.remove(at: child.offset)
            }
        }
    }
    
}
