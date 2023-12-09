//
//  DailyForecast.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 05.12.2023.
//

import Foundation

struct DailyForecast: DailyForecastProtocol {
    public var time: String
    public var temp: Float
    public var isDay: Bool
    public var condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case time, condition
        case temp = "temp_c"
        case isDay = "is_day"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temp = try container.decode(Float.self, forKey: .temp)
        
        let isDay = try container.decode(Int.self, forKey: .isDay)
        self.isDay = isDay == 0 ? false : true
        
        self.condition = try container.decode(Condition.self, forKey: .condition)
        self.time = try container.decode(String.self, forKey: .time)
    }
}
