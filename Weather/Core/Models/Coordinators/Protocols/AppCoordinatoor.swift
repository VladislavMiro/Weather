//
//  AppCoordinatoorProtocol.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 10.12.2023.
//

import UIKit

final class AppCoordinator {
    
    //MARK: - Private fields
    
    private var childProtocols: [CoordinatorProtocol]
    
    private let window: UIWindow
    
    //MARK: - Initialaizers
    
    public init(window: UIWindow) {
        self.window = window
        self.childProtocols = []
    }
    
}

//MARK: Coordinator protocol implementation

extension AppCoordinator: CoordinatorProtocol {
    public func start() {
        let view = UIViewController()
        view.view.backgroundColor = .blue
        
        window.rootViewController = view
        window.makeKeyAndVisible()
    }
    
    public func childFinish(coordinator: CoordinatorProtocol) {
        childProtocols.enumerated().forEach { child in
            if child.element === coordinator {
                childProtocols.remove(at: child.offset)
            }
        }
    }
    
    
}
