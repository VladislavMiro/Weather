//
//  MainViewCoordinator.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 01.12.2023.
//

import UIKit

final class MainViewCoordinator {
    
    //MARK: - Private fields
    
    private let tab1 = UINavigationController()
    private let tab2 = UINavigationController()
    private let window: UIWindow
    
    private let factory: MainViewFactoryProtocol
    
    private var childCoordinators = [CoordinatorProtocol]()
    
    //MARK: - Initializers
    
    public init(window: UIWindow) {
        self.window = window
        self.factory = MainViewFactory()
    }
    
}

extension MainViewCoordinator: MainViewCoordinatorProtocol {
    
    
    
    public func openWeatherView() {
        
        /*//childCoordinators.removeAll()
        //tab2.viewControllers.removeAll()
        
        let factory = WeatherViewModuleFactory(networkManager: NetworkManager(),
                                               locationManager: LocationManager())
        
        let coordinator = WeatherViewCoordinator(parentCoordinator: self, navigationController: tab1,
                                                 moduleFactory: factory)

        
        coordinator.start()
        //childCoordinators.append(coordinator)
        print(childCoordinators.count)*/
    }
    
    public func openWeatherListView() {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = .init(width: UIScreen.main.bounds.width - 20, height: 100)
        
        let view = CollectionView(collectionViewLayout: layout)
        
        tab2.pushViewController(view, animated: false)
        /*//tab1.viewControllers.removeAll()
        
        let factory = WeatherListViewFactory()
        let coordinator = WeatherListViewCoordinator(navigationController: tab2, factory: factory)
        
        coordinator.start()
        
        //childCoordinators.append(coordinator)*/
    }
    
}

extension MainViewCoordinator: CoordinatorProtocol {
    
    public func start() {
        
        tab1.tabBarItem = .init(title: "Current", image: UIImage(systemName: "location.fill"), tag: 0)
        tab2.tabBarItem = .init(title: "List", image: .init(systemName: "list.bullet"), tag: 1)

        
        let view = factory.createMainView(coordinator: self,
                                          tabs: [tab1, tab2])
        
        self.window.rootViewController = view
        self.window.makeKeyAndVisible()
        
    }
    
    public func childFinish(coordinator: CoordinatorProtocol) {
        
        childCoordinators.enumerated().forEach { child in
            if child.element === coordinator {
                childCoordinators.remove(at: child.offset)
            }
        }
        
    }
    
}
