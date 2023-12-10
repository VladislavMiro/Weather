//
//  RoutableCoordinatorProtocol.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 10.12.2023.
//

import Foundation

protocol RoutableCoordinatorProtocol: AnyObject {
    
    func push(animated: Bool)
    func pushAsRoot(animated: Bool)
    func pop(animated: Bool)
    func popToRoot(animated: Bool)
    
}
