//
//  WeatherProtocol.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 07.02.2023.
//

import Foundation

protocol WeatherProtocol: Decodable {
    var location: LocationProtocol { get }
    var current: WeatherDataProtocol { get }
    var forecast: [ForecastProtocol] { get }
}
