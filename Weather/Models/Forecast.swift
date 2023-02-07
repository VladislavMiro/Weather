//
//  Forecast.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 07.02.2023.
//

import Foundation

struct Forecast: ForecastProtocol {
    var date: String
    var day: DayProtocol
    var hour: [WeatherDataProtocol]
    
    private enum CodingKeys: String, CodingKey {
       case date, day, hour
    }
    
    init(date: String, day: DayProtocol, hour: [WeatherDataProtocol]) {
        self.date = date
        self.day = day
        self.hour = hour
    }
    
    init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        
        self.date = try data.decode(String.self, forKey: .date)
        self.day = try data.decode(Day.self, forKey: .day)
        self.hour = try data.decode([WeatherData].self, forKey: .hour)
    }
    
}
