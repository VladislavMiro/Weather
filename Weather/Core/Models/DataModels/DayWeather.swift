//
//  DayWeather.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 05.12.2023.
//

import Foundation

struct DayWeather: DayWeatherProtocol {
    var maxTemp: Float
    var minTemp: Float
    var chanceOfRain: Int
    var chanceOfShow: Int
    var condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case condition
        case maxTemp = "maxtemp_c"
        case minTemp = "mintemp_c"
        case chanceOfRain = "daily_will_it_rain"
        case chanceOfShow = "daily_chance_of_snow"
    }
}
