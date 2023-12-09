//
//  CurrentWeatherProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 04.12.2023.
//

import Foundation

protocol CurrentWeatherProtocol: Decodable {
    var temp: Float { get }
    var isDay: Bool { get }
    var condition: Condition { get }
    var wind: Float { get }
    var humidity: Int { get }
    var cloud: Int { get }
    var feelslikeC: Float { get }
    var visKm: Float { get }
    var uv: Float { get }
    var precip: Float { get }
    var pressure: Float { get }
    var gust: Float { get }
}
