//
//  WeatherResponse.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 03.12.2023.
//

import Foundation

struct WeatherResponse: WeatherResponseProtocol {

    public var location: Region
    public var current: CurrentWeather
    public var forecast: [Forecast]
    
    enum CodingKeys: CodingKey {
        case location, current, forecast
    }
    
    enum ForecastCodingKeys: CodingKey {
        case forecastday
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.location = try container.decode(Region.self, forKey: .location)
        self.current = try container.decode(CurrentWeather.self, forKey: .current)
        
        let forecastContiner = try container.nestedContainer(keyedBy: ForecastCodingKeys.self, forKey: .forecast)
    
        self.forecast = try forecastContiner.decode([Forecast].self, forKey: .forecastday)
    }
}
