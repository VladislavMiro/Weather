//
//  CurrentWeatherProtocol.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 07.02.2023.
//

import Foundation

protocol WeatherDataProtocol: Decodable {
    var tempC: Float { get }
    var tempF: Float { get }
    var condition: ConditionProtocol { get }
    var feelslikeC: Float { get }
    var feelslikeF: Float { get }
    var isDay: Bool { get }
    var humidity: Int { get }
    var cloud: Int { get }
    var windKph: Float { get }
    var windMph: Float { get }
    var uv: Float { get }
}
