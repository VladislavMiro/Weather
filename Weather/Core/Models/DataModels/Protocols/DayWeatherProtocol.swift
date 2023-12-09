//
//  DayWeatherProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 05.12.2023.
//

import Foundation

protocol DayWeatherProtocol: Decodable {
    var maxTemp: Float { get }
    var minTemp: Float { get }
    var chanceOfRain: Int { get }
    var chanceOfShow: Int { get }
    var condition: Condition { get }
}
