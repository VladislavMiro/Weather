//
//  WeatherViewDataModels.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 04.12.2023.
//

import Foundation

enum WeatherViewDataModels {
    
    struct HeaderOutputData {
        var regionName: String
        var temperature: String
        var description: String
        var icon: String
    }
    
    struct DayForecastCellOutputData {
        var time: String
        var temperature: String
        var icon: String
    }
    
    struct WeekForecastOutputData {
        var day: String
        var icon: String
        var condition: String
        var temperature: String
    }
    
    struct AirConditionOutputData {
        var wind: String
        var chanceOfRain: String
        var realFeel: String
        var uvIndex: String
    }
    
    struct Coordinates {
        let lat: Float
        let lon: Float
    }

}
