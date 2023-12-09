//
//  CurrentWeather.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 04.12.2023.
//

import Foundation

struct CurrentWeather: CurrentWeatherProtocol {
    var temp: Float
    var isDay: Bool
    var condition: Condition
    var wind: Float
    var humidity: Int
    var cloud: Int
    var feelslikeC: Float
    var visKm: Float
    var uv: Float
    var precip: Float
    var pressure: Float
    var gust: Float
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp_c"
        case isDay = "is_day"
        case condition
        case wind = "wind_kph"
        case humidity
        case cloud
        case feelslikeC = "feelslike_c"
        case visKm = "vis_km"
        case uv
        case precip = "precip_mm"
        case pressure = "pressure_mb"
        case gust = "gust_kph"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temp = try container.decode(Float.self, forKey: .temp)
        
        let isDay = try container.decode(Int.self, forKey: .isDay)
        self.isDay = isDay == 0 ? false : true
        
        self.condition = try container.decode(Condition.self, forKey: .condition)
        self.wind = try container.decode(Float.self, forKey: .wind)
        self.humidity = try container.decode(Int.self, forKey: .humidity)
        self.cloud = try container.decode(Int.self, forKey: .cloud)
        self.feelslikeC = try container.decode(Float.self, forKey: .feelslikeC)
        self.visKm = try container.decode(Float.self, forKey: .visKm)
        self.uv = try container.decode(Float.self, forKey: .uv)
        self.precip = try container.decode(Float.self, forKey: .precip)
        self.pressure = try container.decode(Float.self, forKey: .pressure)
        self.gust = try container.decode(Float.self, forKey: .gust)
    }
}
