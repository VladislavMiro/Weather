//
//  MainViewFactoryProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 07.12.2023.
//

import UIKit

protocol MainViewFactoryProtocol: AnyObject {
    
    func createMainView(coordinator: MainViewCoordinatorProtocol, tabs: [UIViewController]) -> UIViewController
    
}
