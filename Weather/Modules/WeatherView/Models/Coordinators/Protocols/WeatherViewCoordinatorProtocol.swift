//
//  WeatherViewCoordinatorProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 05.12.2023.
//

import Foundation
import UIKit

protocol WeatherViewCoordinatorProtocol: AnyObject {
    
    func openDetailAirConditionView(data: WeatherResponseProtocol)
    func finish()
    
}
