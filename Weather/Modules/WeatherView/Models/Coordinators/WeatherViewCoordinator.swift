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

    private var childCoordinators: [CoordinatorProtocol] = [] 
    
    private let navigationController: UINavigationController
    private let moduleFactory: WeatherViewModuleFactory
    private weak var parentCoordinator: CoordinatorProtocol?
    
    //MARK: - Initialaizer
    
    public init(parentCoordinator: CoordinatorProtocol, navigationController: UINavigationController, moduleFactory: WeatherViewModuleFactory) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
        self.parentCoordinator = parentCoordinator
    }
    
}

extension WeatherViewCoordinator: WeatherViewCoordinatorProtocol {
    
    public func openDetailAirConditionView(data: WeatherResponseProtocol) {
        let coordinator = DetailAirConditionCoordinator(data: data, navigationController: self.navigationController, parentCoordinator: self, moduleFactory: self.moduleFactory)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    public func finish() {
        parentCoordinator?.childFinish(coordinator: self)
    }
    
}

extension WeatherViewCoordinator: CoordinatorProtocol {
    
    public func start() {
        let view = moduleFactory.createWeatherView(coordinator: self)
        navigationController.pushViewController(view, animated: false)
    }
    
    public func childFinish(coordinator: CoordinatorProtocol) {
        childCoordinators.enumerated().forEach { child in
            if child.element === coordinator {
                childCoordinators.remove(at: child.offset)
            }
        }
    }
    
}

extension WeatherViewCoordinator: RoutableCoordinatorProtocol {
    
    public func push(animated: Bool) {
        let view = moduleFactory.createWeatherView(coordinator: self)
        navigationController.pushViewController(view, animated: animated)
    }
    
    public func pushAsRoot(animated: Bool) {
        let view = moduleFactory.createWeatherView(coordinator: self)
        navigationController.viewControllers = [view]
    }
    
    public func pop(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
    
    public func popToRoot(animated: Bool) {
        parentCoordinator?.childFinish(coordinator: self)
        navigationController.popToRootViewController(animated: animated)
    }
    
    
}
