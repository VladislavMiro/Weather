//
//  WeatherResponseProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 03.12.2023.
//

import Foundation

protocol WeatherResponseProtocol: Decodable {
    var location: Region { get }
    var current: CurrentWeather { get }
    var forecast: [Forecast] { get } 
}
