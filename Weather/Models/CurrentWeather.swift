//
//  CurrentWeather.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 07.02.2023.
//

import Foundation

struct CurrentWeather: CurrentWeatherProtocol {
    var tempC: Float
    var tempF: Float
    var condition: ConditionProtocol
    var feelslikeC: Float
    var feelslikeF: Float
    var isDay: Bool
    var humidity: Int
    var cloud: Int
    var windKph: Float
    var windMph: Float
    var uv: Float
    
    private enum CodingKeys: String, CodingKey, CaseIterable {
        case humidity, cloud, uv, condition, tempC, tempF, feelslikeC, feelslikeF, isDay, windKph, windMph
    }
    
    init(tempC: Float, tempF: Float, condition: ConditionProtocol, feelslikeC: Float,
         feelslikeF: Float, isDay: Bool, humidity: Int, cloud: Int, windKph: Float,
         windMph: Float, uv: Float) {
        self.tempC = tempC
        self.tempF = tempF
        self.condition = condition
        self.feelslikeC = feelslikeC
        self.feelslikeF = feelslikeF
        self.humidity = humidity
        self.cloud = cloud
        self.windKph = windKph
        self.windMph = windMph
        self.uv = uv
        self.isDay = isDay
    }
    
    init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        
        self.tempC = try data.decode(Float.self, forKey: .tempC)
        self.tempF = try data.decode(Float.self, forKey: .tempF)
        self.condition = try data.decode(Condition.self, forKey: .condition)
        self.feelslikeC = try data.decode(Float.self, forKey: .feelslikeC)
        self.feelslikeF = try data.decode(Float.self, forKey: .feelslikeF)
        self.humidity = try data.decode(Int.self, forKey: .humidity)
        self.cloud = try data.decode(Int.self, forKey: .cloud)
        self.windKph = try data.decode(Float.self, forKey: .windKph)
        self.windMph = try data.decode(Float.self, forKey: .windMph)
        self.uv = try data.decode(Float.self, forKey: .uv)
        let isDayInt = try data.decode(Int.self, forKey: .isDay)
        
        if isDayInt == 1 {
            isDay = true
        } else {
            isDay = false
        }
    }
}
