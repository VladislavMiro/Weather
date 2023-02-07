//
//  ForecastProtocol.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 07.02.2023.
//

import Foundation

protocol ForecastProtocol: Decodable {
    var date: String { get }
    var day: DayProtocol { get }
    var hour: [WeatherDataProtocol] { get }
}
