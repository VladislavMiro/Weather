//
//  DetailAitConditionCoordinator.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 06.12.2023.
//

import Foundation
import UIKit

final class DetailAirConditionCoordinator {
    
    //MARK: - Private fields
    
    private let navigationController: UINavigationController
    private let data: WeatherResponseProtocol
    private weak var parentCoordinator: CoordinatorProtocol?
    private var childCoordinator: [CoordinatorProtocol]
    
    private let factory: WeatherViewModuleFactoryProtocol
    
    //MARK: - Initializers
    
    public init(data: WeatherResponseProtocol,
                navigationController: UINavigationController,
                parentCoordinator: CoordinatorProtocol? = nil, moduleFactory: WeatherViewModuleFactoryProtocol) {
        self.navigationController = navigationController
        self.data = data
        self.childCoordinator = []
        self.parentCoordinator = parentCoordinator
        self.factory = moduleFactory
    }
}

//MARK: - DetailAirConditionCoordinatorProtocol Implementation

extension DetailAirConditionCoordinator: DetailAirConditionCoordinatorProtocol {
    
    public func didFinish() {
        parentCoordinator?.childFinish(coordinator: self)
    }
    
}

//MARK: - CoordinatorProtocol implementation

extension DetailAirConditionCoordinator: CoordinatorProtocol {
    
    public func start() {
        let view = factory.createDetailAirConditionView(data: data, coordinator: self)
        
        self.navigationController.pushViewController(view, animated: true)
    }
    
    public func childFinish(coordinator: CoordinatorProtocol) {
        childCoordinator.enumerated().forEach { child in
            if child.element === coordinator {
                childCoordinator.remove(at: child.offset)
            }
        }
    }
}
