//
//  ForecastProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 05.12.2023.
//

import Foundation

protocol ForecastProtocol: Decodable {
    var date: String { get }
    var hour: [DailyForecast] { get }
    var day: DayWeather { get }
}
