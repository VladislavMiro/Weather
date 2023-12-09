//
//  CoordinatorProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 05.12.2023.
//

import Foundation
import UIKit

protocol CoordinatorProtocol: AnyObject {
    func start()
    func childFinish(coordinator: CoordinatorProtocol)
}
