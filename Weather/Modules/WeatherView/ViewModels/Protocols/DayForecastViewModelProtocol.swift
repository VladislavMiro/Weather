//
//  DayForecastViewModelProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 05.12.2023.
//

import Foundation
import Combine

protocol DayForecastViewModelProtocol: AnyObject {
    
    typealias Output = WeatherViewDataModels.DayForecastCellOutputData
    
    var refreshData: PassthroughSubject<Void, Never> { get }
    var data: PassthroughSubject<WeatherResponseProtocol, Never> { get }
    var output: [Output] { get }
    
}
