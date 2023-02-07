//
//  Weather.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 07.02.2023.
//

import Foundation

struct Weather: WeatherProtocol {
    
    var location: LocationProtocol
    var current: WeatherDataProtocol
    var forecast: [ForecastProtocol]
    
    private enum CodingKeys: String, CodingKey {
        case location, current, forecast
    }
    
    private enum ForecastCodingKeys: String, CodingKey {
        case forecastday
    }
    
    init(location: LocationProtocol, current: WeatherDataProtocol, forecast: [ForecastProtocol]) {
        self.location = location
        self.current = current
        self.forecast = forecast
    }
    
    init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        
        self.location = try data.decode(Location.self, forKey: .location)
        self.current = try data.decode(WeatherData.self, forKey: .current)
        
        let forecastData = try data.nestedContainer(keyedBy: ForecastCodingKeys.self, forKey: .forecast)
        
        self.forecast = try forecastData.decode([Forecast].self, forKey: .forecastday)
    }
}
