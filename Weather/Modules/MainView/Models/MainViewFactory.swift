//
//  MainViewFactory.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 07.12.2023.
//

import UIKit

final class MainViewFactory {

}

extension MainViewFactory: MainViewFactoryProtocol {
    
    public func createMainView(coordinator: MainViewCoordinatorProtocol, tabs: [UIViewController]) -> UIViewController {
        
        let viewModel = MainViewModel(coordinator: coordinator)
        let view = MainViewController(viewModel: viewModel)
        
        view.viewControllers = tabs
        
        return view
    }

}
