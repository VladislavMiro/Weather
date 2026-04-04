//
//  AirConditionsItems.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 04.04.2026.
//

import Foundation

enum AirConditionsItems {
    case FeelsLike
    case Wind
    case MinTemperature
    case MaxTemperatures
    case ChanceOfRain
    case ChanceOfSnow
    case Hummidity
    case Visibility
    case Precipitation
    case Pressure
    case Gust
    case UVIndex
    
    var localizedLabel: String {
        switch self {
        case .FeelsLike:
            R.string.localizable.airConditionsItemFeelsLike()
        case .Wind:
            R.string.localizable.airConditionsItemWind()
        case .MinTemperature:
            R.string.localizable.airConditionsItemMinTemperature()
        case .MaxTemperatures:
            R.string.localizable.airConditionsItemMaxTemperature()
        case .ChanceOfRain:
            R.string.localizable.airConditionsItemChanceOfRain()
        case .ChanceOfSnow:
            R.string.localizable.airConditionsItemChanceOfSnow()
        case .Hummidity:
            R.string.localizable.airConditionsItemHummidity()
        case .Visibility:
            R.string.localizable.airConditionsItemVisibility()
        case .Precipitation:
            R.string.localizable.airConditionsItemPrecipitation()
        case .Pressure:
            R.string.localizable.airConditionsItemPressure()
        case .Gust:
            R.string.localizable.airConditionsItemGust()
        case .UVIndex:
            R.string.localizable.airConditionViewUvIndexItemLabel()
        }
    }
    
    var imageName: String {
        switch self {
        case .FeelsLike: "thermometer.medium"
        case .Wind: "wind"
        case .MinTemperature: "thermometer.low"
        case .MaxTemperatures: "thermometer.high"
        case .ChanceOfRain: "cloud.rain"
        case .ChanceOfSnow: "cloud.snow"
        case .Hummidity: "humidity"
        case .Visibility: "eye"
        case .Precipitation: "cloud.drizzle.fill"
        case .Pressure: "cloud.circle"
        case .Gust: "aqi.medium"
        case .UVIndex: "sun.max.fill"
        }
        
    }
}
