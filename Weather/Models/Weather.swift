//
//  Weather.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 07.02.2023.
//

import Foundation

struct Weather: WeatherProtocol {
    
    var location: LocationProtocol
    var current: CurrentWeatherProtocol
    
    init(location: LocationProtocol, current: CurrentWeatherProtocol) {
        self.location = location
        self.current = current
    }
    
    enum CodingKeys: String, CodingKey {
        case location
        case current
    }
    
    init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        
        self.location = try data.decode(Location.self, forKey: .location)
        self.current = try data.decode(CurrentWeather.self, forKey: .current)
    }
}
