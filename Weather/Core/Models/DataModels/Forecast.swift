//
//  Forecast.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 05.12.2023.
//

import Foundation

struct Forecast: ForecastProtocol {
    public var date: String
    public var hour: [DailyForecast]
    public var day: DayWeather
}
