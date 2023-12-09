//
//  WeatherListOutput.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 08.12.2023.
//

import Foundation

struct WeatherListOutput: Hashable {
    let uid: UUID = UUID()
    let temperature: String
    let region: String
    let image: String
    
    init(temperature: String, region: String, image: String) {
        self.temperature = temperature
        self.region = region
        self.image = image
    }
    
    init(data: WeatherResponseProtocol) {
        self.temperature = String(Int(data.current.temp)) + Resources.Symbols.celciusSymbol
        self.region = data.location.name + ", " + data.location.country
        let isDay = data.current.isDay
        
        self.image = (isDay ? "d" : "n") + data.current.condition.icon
    }
}
