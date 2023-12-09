//
//  DailyForecastProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 05.12.2023.
//

import Foundation

protocol DailyForecastProtocol: Decodable {
    var time: String { get }
    var temp: Float { get }
    var isDay: Bool { get }
    var condition: Condition { get }
}
